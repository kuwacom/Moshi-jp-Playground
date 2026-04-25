# Vendored Moshi

This directory vendors the `moshi` Python package used by this repository.

## Local changes

- Added compatibility loading for q8 checkpoints that store attention weights as `in_projs.*` / `out_projs.*`
- This lets `shunby/llm-jp-moshi-v1-q8` load on top of the current `moshi==0.2.2` codebase
