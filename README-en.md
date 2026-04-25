# Moshi-jp-Playground

[![Japanese](https://img.shields.io/badge/README-Japanese-red.svg)](README.md)

This repository is a small playground for running LLM-jp-Moshi-v1 on a local GPU machine.
It is intended as a derivative setup repository rather than the canonical upstream project, bundling `uv`-based environment setup, startup scripts, and local cache locations in one place.

> [!NOTE]
> LLM-jp-Moshi-v1 is still a prototype model, and responses may be unnatural

## What This Repository Provides

- A quick `uv sync` based setup flow
- A simple `./start.sh` entry point for the Web UI
- Persistent local model cache under `models/huggingface/`
- A shortcut script for the quantized `shunby/llm-jp-moshi-v1-q8` variant
- A vendored local `moshi` copy under `vendor/moshi` for reproducible setup across machines

## Requirements

- Linux
- Python `>=3.10, <3.13`
- `uv`
- A CUDA-capable GPU environment

Recommended in practice:

- 24GB or more VRAM is helpful for the standard model path
- Earphones or headphones are recommended when using the Web UI to avoid audio feedback

## Quick Start

```bash
uv sync
./start.sh
```

After startup, open the URL printed in the terminal.

## Setup

### 1. Install dependencies

```bash
uv sync
```

If you prefer not to use `uv`, this also works:

```bash
pip install "moshi==0.2.2" "sphn==0.1.4"
```

### 2. Start the model

Run the standard LLM-jp-Moshi-v1 setup:

```bash
./start.sh
```

Explicitly choose the Hugging Face repo if needed:

```bash
HF_REPO=llm-jp/llm-jp-moshi-v1 ./start.sh
```

Run the quantized variant:

```bash
./startQ8.sh
```

### 3. Run `moshi.server` directly

```bash
uv run python -m moshi.server --hf-repo llm-jp/llm-jp-moshi-v1
```

That works, but `start.sh` is usually more convenient because it also sets cache directories and safer defaults for older GPUs.

## Startup Scripts

### `start.sh`

Starts the standard `llm-jp/llm-jp-moshi-v1` model and sets these defaults:

- `UV_CACHE_DIR=.uv-cache`
- `HF_HOME=models/huggingface`
- `HF_HUB_CACHE=models/huggingface/hub`
- `NO_TORCH_COMPILE=1`
- `MOSHI_USE_HALF=1`

When `MOSHI_USE_HALF=1`, the script adds `--half`.
This favors `float16` compatibility on older GPUs where `bfloat16` may be less practical.

### `startQ8.sh`

Runs `start.sh` with `HF_REPO=shunby/llm-jp-moshi-v1-q8`.
Use it when you want a quick path to the quantized model.

## Vendored `moshi`

This repository vendors the `moshi` package under `vendor/moshi`.
`uv` is configured to prefer this local copy so the setup is easier to reproduce on another machine.

The compatibility logic for loading `shunby/llm-jp-moshi-v1-q8` lives in [vendor/moshi/moshi/models/loaders.py](/mnt/sdb/main/llm-jp-moshi/vendor/moshi/moshi/models/loaders.py:236).

### Local changes

- `uv` is configured to use `vendor/moshi` as the local `moshi` dependency
- Added compatibility loading that remaps q8 attention weights stored as `in_projs.*` / `out_projs.*` into the current `moshi==0.2.2` layout

## Common Environment Variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `HF_REPO` | `llm-jp/llm-jp-moshi-v1` | Hugging Face model repo to launch |
| `HF_HOME` | `./models/huggingface` | Hugging Face cache root |
| `HF_HUB_CACHE` | `./models/huggingface/hub` | Hugging Face Hub cache |
| `UV_CACHE_DIR` | `./.uv-cache` | `uv` cache location |
| `NO_TORCH_COMPILE` | `1` | Disables `torch.compile` for compatibility |
| `MOSHI_USE_HALF` | `1` | Adds `--half` on startup |

Examples:

```bash
MOSHI_USE_HALF=0 ./start.sh
HF_HOME=/data/hf-cache ./start.sh
HF_REPO=shunby/llm-jp-moshi-v1-q8 ./start.sh
```

## Directory Layout

```text
.
|-- README.md
|-- README-en.md
|-- pyproject.toml
|-- uv.lock
|-- start.sh
|-- startQ8.sh
|-- models/
|   `-- huggingface/    # Created at runtime for model cache
`-- static/             # Static assets for the project page
```

## Notes

- MacOS is not a target environment here
- The first launch can take a while because model files must be downloaded
- Stability and performance may differ depending on whether `--half` is enabled
- Always check the upstream repository and the model page for the latest usage conditions

## Acknowledgments

Thanks to Kyutai Labs for publishing Moshi and its related implementation.
Thanks also to the llm-jp project for releasing LLM-jp-Moshi-v1 and the related public materials.

## Links

- **Upstream repository:** [llm-jp/llm-jp-moshi](https://github.com/llm-jp/llm-jp-moshi)
- **Model:** [llm-jp/llm-jp-moshi-v1](https://huggingface.co/llm-jp/llm-jp-moshi-v1)
- **Quantized model:** [shunby/llm-jp-moshi-v1-q8](https://huggingface.co/shunby/llm-jp-moshi-v1-q8)
- **Official demo:** [llm-jp.github.io/llm-jp-moshi](https://llm-jp.github.io/llm-jp-moshi/)
- **Base implementation:** [kyutai-labs/moshi](https://github.com/kyutai-labs/moshi)
- **Paper:** [Effects of dialogue corpora properties on fine-tuning a Moshi-based spoken dialogue model](https://aclanthology.org/2026.iwsds-1.10/)
