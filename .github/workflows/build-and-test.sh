#! /bin/bash
# Copyright (C) 2020-2021  The SymbiFlow Authors.
#
# Use of this source code is governed by a ISC-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/ISC
#
# SPDX-License-Identifier:ISC

set -e

source .github/workflows/common.sh

##########################################################################

start_section Building
make UHDM_INSTALL_DIR=$HOME/.local-bin plugins -j`nproc`
end_section

##########################################################################

start_section Installing
make install -j`nproc`
end_section

##########################################################################

#Disable testing, as for now there isn't any uhdm-plugin related tests
#and some other test is failing
#start_section Testing
#make test -j`nproc`
#end_section

##########################################################################

start_section Cleanup
make clean -j`nproc`
end_section

##########################################################################
