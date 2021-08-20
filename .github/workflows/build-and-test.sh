#! /bin/bash

set -e

source .github/workflows/common.sh

##########################################################################

start_section Building
make UHDM_INSTALL_DIR=$HOME/.local-bin  plugins -j`nproc`
end_section

##########################################################################

start_section Installing
make install -j`nproc`
end_section

##########################################################################

start_section Testing
make test -j`nproc`
end_section

##########################################################################

start_section Cleanup
make clean -j`nproc`
end_section

##########################################################################
