# プログラム一式
git clone http://34.168.41.36/git/shirai/fine-tune.git


# リポジトリ取得（現在は ggml-org へ移管されています）
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

~/llama.cpp/build/bin/llama-cli -m model-f16.gguf -cnv


~/llama.cpp/build/bin/llama-quantize ./model-f16.gguf ./model-q4_k_m.gguf Q4_K_M
~/llama.cpp/build/bin/llama-cli -m model-q4_k_m.gguf -cnv



ollama create my/model-q4 -f Modelfile
