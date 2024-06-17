#!/bin/bash
# Install nvm for zshell
source ${NVM_DIR}/nvm.sh
nvm install 18
npm install -g yarn

pip install --upgrade pip
pip install -r requirements.txt
