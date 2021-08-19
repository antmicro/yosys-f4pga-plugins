#! /bin/bash

set -e

source .github/workflows/common.sh

##########################################################################

# Output status information.
start_section Status
(
    set +e
    set -x
    git status
    git branch -v
    git log -n 5 --graph
    git log --format=oneline -n 20 --graph
)
end_section

##########################################################################

# Update submodules
start_section Submodules
(
    git submodule update --init --recursive
)
end_section

##########################################################################

#Install yosys
start_section Install-Yosys
(
    if [ ! -e ~/.local-bin/bin/yosys ]; then
        echo '=========================='
        echo 'Building yosys'
        echo '=========================='
        mkdir -p ~/.local-src
        mkdir -p ~/.local-bin
        cd ~/.local-src
        git clone https://github.com/antmicro/yosys.git -b uhdm-kr/yosys-uhdm-plugin-cleanup
        cd yosys
        PREFIX=$HOME/.local-bin make -j$(nproc)
        PREFIX=$HOME/.local-bin make install
        echo $(which yosys)
        echo $(which yosys-config)
        echo $(yosys-config --datdir)
        cd ..
    fi
)
end_section

start_section Install-Surelog
(
    if [ ! -e ~/.local-bin/bin/surelog ]; then
        echo '=========================='
        echo 'Building surelog'
        echo '=========================='
        mkdir -p ~/.local-src
        mkdir -p ~/.local-bin
        cd ~/.local-src
        git clone --recursive https://github.com/chipsalliance/Surelog.git -b master
        cd Surelog
        cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local-bin -DCMAKE_POSITION_INDEPENDENT_CODE=ON -S . -B build
	cmake --build build -j $(nproc)
	cmake --install build
	cd ..
    fi
)
end_section

##########################################################################

