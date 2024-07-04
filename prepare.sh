#!/bin/bash

set -eux

CURDIR=$(dirname $(realpath $0))

cd $CURDIR

# download kunai v0.2.4
ARCH=$(uname -m)
if [[ $ARCH == "x86_64" ]]
then
    /usr/bin/wget -O kunai https://github.com/kunai-project/kunai/releases/download/v0.2.4/kunai-amd64
    chmod +x kunai
fi

if [[ $ARCH == "aarch64" ]]
then
    /usr/bin/wget -O kunai https://github.com/kunai-project/kunai/releases/download/v0.2.4/kunai-aarch64
    chmod +x kunai
fi

if [[ ! -d "tools" ]]
then
    git clone https://github.com/kunai-project/tools
fi

if [[ ! -d "malware-dataset" ]]
then
    git clone https://helga.circl.lu/NGSOTI/malware-dataset
fi

# installing requirements
cd tools
python -m venv .env
source .env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
