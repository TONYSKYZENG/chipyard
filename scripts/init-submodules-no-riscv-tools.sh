#!/usr/bin/env bash

# wrapper to log output from init-submodules script

set -e
set -o pipefail

RDIR=$(git rev-parse --show-toplevel)
cd ../generators
rm -rf testchipip
rm -rf rocket-chip
git clone https://github.com/TONYSKYZENG/testchipip.git
git clone https://github.com/TONYSKYZENG/rocket-chip.git
cd "$RDIR"
./scripts/init-submodules-no-riscv-tools-nolog.sh "$@" 2>&1 | tee init-submodules-no-riscv-tools.log
