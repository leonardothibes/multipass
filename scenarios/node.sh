#!/bin/bash

clear

HERE=$(dirname $0)
BASE="${HERE}/base.sh"
VERSION=16

if [ -f $BASE ]; then
    source $BASE
    base
# else
#     sh -c "$(curl -fsSL https://raw.githubusercontent.com/leonardothibes/multipass/master/scenarios/base.sh)"
fi

function nvm()
{
    LOCK=/tmp/lock.node.nvm
    [ -f ${LOCK} ] && return

    echo " - Installing NVM..."

    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash > /dev/null 2>&1

    source ~/.profile

    # > ${LOCK}

}

function node()
{
    echo " - Installing Node.js ${VERSION}..."

}

function main()
{
    echo "Installing Node.js development scenario"

    nvm
    node

    echo ""
    echo "Done!"
}

main
