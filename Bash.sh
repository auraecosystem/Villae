brew install git-xet
git xet install
git clone https://huggingface.co/datasets/aidigestorg/ai-village
GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/datasets/aidigestorg/ai-village
hf download aidigestorg/ai-village --repo-type=dataset
