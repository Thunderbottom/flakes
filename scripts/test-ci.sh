#!/usr/bin/env bash
# Offline integration tests: real local Git repositories, mocked HTTP/build tools.
set -euo pipefail
source_dir=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.invalid
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.invalid
export TOKEN=test SERVER_URL=https://example.invalid REPOSITORY=owner/repo
export TEST_STATE="$tmp/state"
mkdir -p "$tmp/bin" "$TEST_STATE"
cat >"$tmp/bin/curl" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
if [[ " $* " == *' --data '* ]]; then
  if [[ -f $TEST_STATE/post-failure ]]; then exit 22; fi
  touch "$TEST_STATE/pr"
  echo post >> "$TEST_STATE/requests"
  if [[ -f $TEST_STATE/ambiguous ]]; then exit 28; fi
  printf '{"number":1}\n'
else
  if [[ -f $TEST_STATE/read-failure ]]; then exit 22; fi
  echo get >> "$TEST_STATE/requests"
  if [[ -f $TEST_STATE/pr ]]; then
    printf '[{"number":1,"head":{"ref":"automation/flake-update","repo":{"owner":{"login":"owner"}}},"base":{"ref":"main"}}]\n'
  else
    printf '[]\n'
  fi
fi
MOCK
cat >"$tmp/bin/nix-fast-build" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$TEST_STATE/build-args"
MOCK
chmod +x "$tmp/bin/"*
export PATH="$tmp/bin:$PATH"
git init --bare --quiet "$tmp/remote.git"
git init --quiet --initial-branch=main "$tmp/work"
cd "$tmp/work"
git remote add origin "$tmp/remote.git"
printf 'original\n' >flake.lock
git add flake.lock
git commit --quiet -m initial
git push --quiet origin main
base=$(git rev-parse HEAD)
branch=refs/heads/automation/flake-update

# No changes: no API calls or automation branch.
bash "$source_dir/ci-update.sh"
[[ ! -f $TEST_STATE/requests ]]
[[ -z $(git ls-remote origin "$branch") ]]

# First publication: create branch and PR.
printf 'updated\n' >flake.lock
bash "$source_dir/ci-update.sh"
first=$(git ls-remote origin "$branch")
[[ $(grep -c '^post$' "$TEST_STATE/requests") == 1 ]]

# Same generated lock: preserve remote commit and reuse PR.
git reset --hard --quiet "$base"
printf 'updated\n' >flake.lock
bash "$source_dir/ci-update.sh"
[[ $(git ls-remote origin "$branch") == "$first" ]]
[[ $(grep -c '^post$' "$TEST_STATE/requests") == 1 ]]

# Branch published but PR missing: recover without rewriting branch.
rm "$TEST_STATE/pr"
bash "$source_dir/ci-update.sh"
[[ $(git ls-remote origin "$branch") == "$first" ]]
[[ $(grep -c '^post$' "$TEST_STATE/requests") == 2 ]]

# New content: update branch, still reuse existing PR.
printf 'newer\n' >flake.lock
bash "$source_dir/ci-update.sh"
[[ $(git ls-remote origin "$branch") != "$first" ]]
[[ $(grep -c '^post$' "$TEST_STATE/requests") == 2 ]]

# Lost POST response: discover the created PR rather than POST twice.
rm "$TEST_STATE/pr"
touch "$TEST_STATE/ambiguous"
printf 'newest\n' >flake.lock
bash "$source_dir/ci-update.sh"
[[ $(grep -c '^post$' "$TEST_STATE/requests") == 3 ]]

# Read errors and definite POST failures remain failures, not false success.
git reset --hard --quiet "$base"
printf 'newest\n' >flake.lock
touch "$TEST_STATE/read-failure"
if bash "$source_dir/ci-update.sh"; then
  echo 'Expected API read failure' >&2
  exit 1
fi
rm "$TEST_STATE/read-failure" "$TEST_STATE/pr"
touch "$TEST_STATE/post-failure"
if bash "$source_dir/ci-update.sh"; then
  echo 'Expected unrecovered POST failure' >&2
  exit 1
fi
rm "$TEST_STATE/post-failure"

# Remote transport failures must not look like an absent branch.
git remote set-url origin "$tmp/missing.git"
if bash "$source_dir/ci-update.sh"; then
  echo 'Expected Git transport failure' >&2
  exit 1
fi
git remote set-url origin "$tmp/remote.git"

# A competing writer between fetch and push must not be overwritten.
export REAL_GIT
REAL_GIT=$(command -v git)
export TEST_REMOTE="$tmp/remote.git" TEST_BASE="$base"
cat >"$tmp/bin/git" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
if [[ ${1:-} == push ]]; then
  "$REAL_GIT" --git-dir="$TEST_REMOTE" update-ref refs/heads/automation/flake-update "$TEST_BASE"
fi
exec "$REAL_GIT" "$@"
MOCK
chmod +x "$tmp/bin/git"
printf 'concurrent update\n' >flake.lock
if bash "$source_dir/ci-update.sh"; then
  echo 'Expected stale lease rejection' >&2
  exit 1
fi
[[ $(git --git-dir="$TEST_REMOTE" rev-parse "$branch") == "$base" ]]
rm "$tmp/bin/git"

# Build roots are scoped to run and attempt; PRs never create persistent roots.
EVENT=push CI_GCROOTS="$tmp/roots with spaces" RUN_ID=42 RUN_ATTEMPT=2 \
  bash "$source_dir/ci-build.sh"
[[ -d "$tmp/roots with spaces/42-2" ]]
grep -Fx -- "$tmp/roots with spaces/42-2/result" "$TEST_STATE/build-args"
EVENT=pull_request bash "$source_dir/ci-build.sh"
if grep -q -- '--out-link' "$TEST_STATE/build-args"; then
  echo 'PR builds must not create persistent roots' >&2
  exit 1
fi
echo 'CI integration tests passed.'
