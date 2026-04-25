#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${script_dir}"

uv_cache_dir="${UV_CACHE_DIR:-${script_dir}/.uv-cache}"
hf_repo="${HF_REPO:-llm-jp/llm-jp-moshi-v1}"
hf_home_dir="${HF_HOME:-${script_dir}/models/huggingface}"
hf_hub_cache_dir="${HF_HUB_CACHE:-${hf_home_dir}/hub}"
no_torch_compile="${NO_TORCH_COMPILE:-1}"
moshi_use_half="${MOSHI_USE_HALF:-1}"

# モデルをリポジトリ内に保持して再ダウンロードを避ける
mkdir -p "${uv_cache_dir}" "${hf_hub_cache_dir}"

extra_args=()

# P40 のような古い GPU では bfloat16 より float16 の方が実用的
if [[ "${moshi_use_half}" == "1" ]]; then
  extra_args+=(--half)
fi

exec env UV_CACHE_DIR="${uv_cache_dir}" \
  HF_HOME="${hf_home_dir}" \
  HF_HUB_CACHE="${hf_hub_cache_dir}" \
  NO_TORCH_COMPILE="${no_torch_compile}" \
  uv run python -m moshi.server --hf-repo "${hf_repo}" "${extra_args[@]}" "$@"
