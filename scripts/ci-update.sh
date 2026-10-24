#!/usr/bin/env bash
set -euo pipefail

: "${TOKEN:?}" "${SERVER_URL:?}" "${REPOSITORY:?}"
branch=automation/flake-update
remote_ref="refs/heads/$branch"
tracking_ref="refs/remotes/origin/$branch"
api="${SERVER_URL%/}/api/v1/repos/$REPOSITORY"
owner="${REPOSITORY%%/*}"

# Retry safe reads, but never blindly retry a mutating API request.
api_get() {
  curl --fail-with-body --silent --show-error \
    --connect-timeout 10 --max-time 60 --retry 3 \
    -H "Authorization: token $TOKEN" "$@"
}

find_pr() {
  api_get --get "$api/pulls" \
    --data-urlencode state=open \
    --data-urlencode "head=$branch" \
    --data-urlencode base=main \
    --data-urlencode limit=50 |
    jq -er --arg branch "$branch" --arg owner "$owner" '
      if type != "array" then error("Expected a pull request array") else
        [.[] | select(.head.ref == $branch and .head.repo.owner.login == $owner
                      and .base.ref == "main")] |
        if length > 1 then error("Multiple update pull requests found")
        elif length == 1 then .[0].number else 0 end
      end'
}

# ls-remote failures must not be mistaken for an absent branch.
remote_sha=$(git ls-remote origin "$remote_ref" | awk '{print $1}')
if [[ -n $remote_sha ]]; then
  git fetch --no-tags origin "+$remote_ref:$tracking_ref"
  remote_sha=$(git rev-parse "$tracking_ref")
fi

if git diff --quiet HEAD -- flake.lock; then
  echo "flake.lock is already up to date; nothing to publish."
  exit 0
fi

if [[ -n $remote_sha ]] &&
  git diff --quiet "$tracking_ref" -- flake.lock &&
  git diff --quiet "$tracking_ref" HEAD -- . ':!flake.lock'; then
  echo "The automation branch already contains this update and current main content."
else
  git -c user.name=ci-bot -c user.email=ci-bot@deku.moe \
    commit -m "chore: update flake.lock" -- flake.lock
  # An empty expected SHA means the branch must not exist yet.
  git push "--force-with-lease=$remote_ref:$remote_sha" origin "HEAD:$remote_ref"
fi

existing=$(find_pr)
if [[ $existing != 0 ]]; then
  echo "Reusing open pull request #$existing."
  exit 0
fi

payload=$(jq -n --arg head "$branch" \
  '{title: "chore: update flake.lock", head: $head, base: "main",
    body: "Automated flake input update. Formatting and evaluation passed before publication; PR CI builds the updated checks."}')

if curl --fail-with-body --silent --show-error \
  --connect-timeout 10 --max-time 60 \
  -H "Authorization: token $TOKEN" -H 'Content-Type: application/json' \
  --data "$payload" "$api/pulls"; then
  echo
  echo "Created the update pull request."
else
  # The server may have accepted the POST even if its response was lost.
  existing=$(find_pr)
  if [[ $existing != 0 ]]; then
    echo "Recovered after an ambiguous response: pull request #$existing exists."
  else
    echo "PR creation failed; rerun the workflow to recover the published branch." >&2
    exit 1
  fi
fi
