#!/usr/bin/env bash
set -euo pipefail

args=(--flake .#checks.x86_64-linux --skip-cached --no-nom
  --eval-workers 2 --eval-max-memory-size 8192)

if [[ ${EVENT:?} == push ]]; then
  : "${CI_GCROOTS:?Runner must provide CI_GCROOTS}" "${RUN_ID:?}" "${RUN_ATTEMPT:?}"
  roots="$CI_GCROOTS/$RUN_ID-$RUN_ATTEMPT"
  mkdir -p "$roots"
  args+=(--out-link "$roots/result")
fi

exec nix-fast-build "${args[@]}"
