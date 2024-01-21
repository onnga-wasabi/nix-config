# asdf terraform とかめんどくさいもののために使えるようにしておく
export ASDF_HASHICORP_OVERWRITE_ARCH=amd64

## asdf completions
fpath=(${ASDF_DIR}/completions $fpath)
