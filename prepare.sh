#!/bin/bash

set -e

CURDIR=$(dirname $(realpath $0))

cd $CURDIR

# download kunai v0.2.4
wget https://github.com/kunai-project/kunai/releases/download/v0.2.4/kunai-aarch64
wget https://github.com/kunai-project/kunai/releases/download/v0.2.4/kunai-amd64

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
