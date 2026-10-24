#!/usr/bin/env bash
set -euo pipefail

: "${NTFY_TOKEN:?}" "${REPO:?}" "${SHA:?}" "${RUN_URL:?}" "${WORKFLOW:?}"
curl --fail-with-body --silent --show-error \
  --connect-timeout 10 --max-time 30 --retry 2 \
  -H "Authorization: Bearer $NTFY_TOKEN" \
  -H "Title: $WORKFLOW failed: $REPO" -H 'Priority: high' -H 'Tags: x' \
  --data-binary "$SHA: $RUN_URL" \
  https://ntfy.deku.moe/nix-ci
