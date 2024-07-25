set shell := ["bash", "-c"]

test:
    cd _generator && ./test.sh basedpyright && ./test.sh typescript_eslint