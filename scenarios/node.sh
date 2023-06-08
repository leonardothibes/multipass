#!/bin/bash

function download()
{
    HERE=$(dirname $0)
    BASE="${HERE}/base.sh"

    if [ -f $BASE ]; then
        source $BASE
    else
        curl -s https://raw.githubusercontent.com/leonardothibes/multipass/master/scenarios/base.sh -o /tmp/base.sh
        source /tmp/base.sh
    fi
}

function nvmTool()
{
    echo " - Installing NVM..."

    LOCK=/tmp/lock.node.nvm
    [ -f ${LOCK} ] && return

    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash > /dev/null 2>&1
    > ${LOCK}
}

function node()
{
    VERSION=$1
    echo " - Installing Node.js ${VERSION}..."

    LOCK=/tmp/lock.node.${VERSION}
    [ -f ${LOCK} ] && return

    HAS=$(which noded | wc -l)
    if [ $HAS == "0" ]; then
        export NVM_DIR="$HOME/.nvm"
        source $NVM_DIR/nvm.sh
        nvm install ${VERSION} > /dev/null 2>&1
    fi

    > ${LOCK}
}

function extras()
{
    echo " - Installing extra tools..."

    LOCK=/tmp/lock.node.extras
    [ -f ${LOCK} ] && return

    PACKAGES="
        npm-check-updates
        node-cpf-cli
        yarn
        uuid
    "

    export NVM_DIR="$HOME/.nvm"
    source $NVM_DIR/nvm.sh
    npm install -g npm@latest > /dev/null 2>&1

    for PACKAGE in ${PACKAGES}
    do
        npm install --ignore-scripts -g ${PACKAGE} > /dev/null 2>&1
    done;

    > ${LOCK}
}

function main()
{
    clear
    echo "Installing Node.js development scenario"
    echo ""

    download
    base
    nvmTool
    node "16"
    extras
    after

    echo ""
    echo "Done!"
}

main
