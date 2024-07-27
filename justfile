set shell := ["bash", "-c"]

generate:
    cd _generator && ./run_generator.sh

test: generate
    cd _generator && ./test.sh basedpyright && ./test.sh typescript_eslint