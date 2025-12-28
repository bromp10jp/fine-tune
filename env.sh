# リポジトリ取得
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp

# 変換スクリプト用の Python 依存
pip install -r requirements.txt

# 2) 変換（まずは f16）
python ../llama.cpp/convert_hf_to_gguf.py ./merged_model_full --outfile model-f16.gguf --outtype f16

# 3) ビルドと実行確認
sudo apt install -y git cmake build-essential ninja-build libcurl4-openssl-dev
cmake -B build -DLLAMA_BUILD_SERVER=OFF -DLLAMA_BUILD_EXAMPLES=OFF -DLLAMA_BUILD_TESTS=OFF
cmake --build build -j4 --target llama-quantize

# 4) 変換（4ビット量子化）
~/llama.cpp/build/bin/llama-quantize ./model-f16.gguf ./model-q4_k_m.gguf Q4_K_M

# Ollamaのモデルデプロイ
ollama create my/model-q4 -f Modelfile
