# Moshi-jp-Playground

[![English](https://img.shields.io/badge/README-English-red.svg)](README-en.md)

LLM-jp-Moshi-v1 をローカル GPU 環境で素早く試すためのプレイグラウンドです。
本家リポジトリの公開情報を参照しつつ、`uv` ベースのセットアップ、起動スクリプト、モデルキャッシュ保存先をひとまとめにしています。

> [!NOTE]
> LLM-jp-Moshi-v1 は試作段階のモデルであり、応答が不自然になる場合があります

## このリポジトリでできること

- `uv sync` で実行環境を用意できる
- `./start.sh` で Web UI を起動できる
- 初回ダウンロードしたモデルを `models/huggingface/` に保持できる
- 量子化版 `shunby/llm-jp-moshi-v1-q8` も `./startQ8.sh` で試せる
- `vendor/moshi` に同梱したローカル `moshi` を使って再現しやすく運用できる

## 前提環境

- Linux
- Python `>=3.10, <3.13`
- `uv`
- CUDA が使える GPU 環境

推奨事項です。

- フル精度に近い構成では 24GB 以上の VRAM があると扱いやすいです
- モデル音声の回り込みを避けるため、Web UI 利用時はイヤホンまたはヘッドホンの利用を推奨します

## クイックスタート

```bash
uv sync
./start.sh
```

起動後、ターミナルに表示された URL をブラウザで開いてください。

## セットアップ

### 1. 依存関係をインストール

```bash
uv sync
```

`uv` を使わずに入れる場合は次でも動きます。

```bash
pip install "moshi==0.2.2" "sphn==0.1.4"
```

### 2. モデルを指定して起動

標準の LLM-jp-Moshi-v1 を起動する場合です。

```bash
./start.sh
```

明示的に Hugging Face リポジトリを指定したい場合です。

```bash
HF_REPO=llm-jp/llm-jp-moshi-v1 ./start.sh
```

量子化版を起動する場合です。

```bash
./startQ8.sh
```

### 3. `moshi.server` を直接使う場合

```bash
uv run python -m moshi.server --hf-repo llm-jp/llm-jp-moshi-v1
```

この場合でも、`start.sh` を使った方がキャッシュ先や GPU 向けの既定値が揃うので楽です。

## 起動スクリプト

### `start.sh`

標準モデル `llm-jp/llm-jp-moshi-v1` を起動します。
次の既定値をまとめて設定します。

- `UV_CACHE_DIR=.uv-cache`
- `HF_HOME=models/huggingface`
- `HF_HUB_CACHE=models/huggingface/hub`
- `NO_TORCH_COMPILE=1`
- `MOSHI_USE_HALF=1`

`MOSHI_USE_HALF=1` のときは `--half` を付けて起動します。
古い GPU で `bfloat16` より `float16` の方が扱いやすいケースを優先した設定です。

### `startQ8.sh`

`HF_REPO=shunby/llm-jp-moshi-v1-q8` を指定して `start.sh` を呼び出します。
量子化版を手早く試したいとき向けです。

## vendor した `moshi`

このリポジトリでは `moshi` パッケージ本体を `vendor/moshi` 配下に同梱しています。
`uv` はこの vendor 版を優先して使う設定で、別環境でも同じ修正を再現しやすくしています。

量子化モデル `shunby/llm-jp-moshi-v1-q8` を読み込むための互換処理は [vendor/moshi/moshi/models/loaders.py](/mnt/sdb/main/llm-jp-moshi/vendor/moshi/moshi/models/loaders.py:236) に入っています。

### 変更点

- `vendor/moshi` をローカル依存として使うよう `uv` を設定
- `in_projs.*` / `out_projs.*` 形式の q8 attention 重みを、現行 `moshi==0.2.2` の `in_proj_weight` / `out_proj.weight` 形式へ読み替える互換処理を追加

## よく使う環境変数

| 変数名 | 既定値 | 用途 |
| --- | --- | --- |
| `HF_REPO` | `llm-jp/llm-jp-moshi-v1` | 起動する Hugging Face モデル |
| `HF_HOME` | `./models/huggingface` | Hugging Face のキャッシュ保存先 |
| `HF_HUB_CACHE` | `./models/huggingface/hub` | Hub キャッシュ保存先 |
| `UV_CACHE_DIR` | `./.uv-cache` | `uv` のキャッシュ保存先 |
| `NO_TORCH_COMPILE` | `1` | `torch.compile` を無効化して互換性を優先 |
| `MOSHI_USE_HALF` | `1` | `--half` を付けて起動するかどうか |

例です。

```bash
MOSHI_USE_HALF=0 ./start.sh
HF_HOME=/data/hf-cache ./start.sh
HF_REPO=shunby/llm-jp-moshi-v1-q8 ./start.sh
```

## ディレクトリ構成

```text
.
|-- README.md
|-- README-en.md
|-- pyproject.toml
|-- uv.lock
|-- start.sh
|-- startQ8.sh
|-- models/
|   `-- huggingface/    # 実行時に作られるモデルキャッシュ
`-- static/             # 紹介ページ用の静的アセット
```

## 注意点

- MacOS は想定していません
- 初回起動時はモデルダウンロードに時間がかかります
- GPU やドライバ構成によっては `--half` の有無で安定性や速度が変わります
- 利用条件やモデルの公開条件は本家の案内を必ず確認してください

## 謝辞

ベースモデルである Moshi および関連実装を公開している Kyutai Labs に感謝します。
また、LLM-jp-Moshi-v1 と関連情報を公開している llm-jp プロジェクトにも感謝します。

## 関連リンク

- **本家リポジトリ:** [llm-jp/llm-jp-moshi](https://github.com/llm-jp/llm-jp-moshi)
- **モデル:** [llm-jp/llm-jp-moshi-v1](https://huggingface.co/llm-jp/llm-jp-moshi-v1)
- **量子化モデル:** [shunby/llm-jp-moshi-v1-q8](https://huggingface.co/shunby/llm-jp-moshi-v1-q8)
- **公式デモ:** [llm-jp.github.io/llm-jp-moshi](https://llm-jp.github.io/llm-jp-moshi/)
- **ベース実装:** [kyutai-labs/moshi](https://github.com/kyutai-labs/moshi)
- **論文:** [Effects of dialogue corpora properties on fine-tuning a Moshi-based spoken dialogue model](https://aclanthology.org/2026.iwsds-1.10/)