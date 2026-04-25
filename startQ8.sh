#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}"

exec env HF_REPO="${HF_REPO:-shunby/llm-jp-moshi-v1-q8}" \
  "${script_dir}/start.sh" "$@"
