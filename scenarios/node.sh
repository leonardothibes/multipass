#!/bin/bash

clear

HERE=$(dirname $0)
BASE="${HERE}/base.sh"

if [ -f $BASE ]; then
    source $BASE
    base
# else
#     sh -c "$(curl -fsSL https://raw.githubusercontent.com/leonardothibes/multipass/master/scenarios/base.sh)"
fi

echo "Installing Node.js development scenario"

echo "Done!"
