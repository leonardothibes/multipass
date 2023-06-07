#!/bin/bash

clear

HERE=$(dirname $0)
BASE="${HERE}/base.sh"
VERSION=16

if [ -f $BASE ]; then
    source $BASE
else
    curl -s https://raw.githubusercontent.com/leonardothibes/multipass/master/scenarios/base.sh -o /tmp/bash.sh
    source /tmp/bash.sh
fi

function nvmTool()
{
    echo " - Installing NVM..."

    LOCK=/tmp/lock.node.nvm
    [ -f ${LOCK} ] && return

    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash > /dev/null 2>&1

    > ${LOCK}
}

function node()
{
    echo " - Installing Node.js ${VERSION}..."

    LOCK=/tmp/lock.node.${VERSION}
    [ -f ${LOCK} ] && return

    sudo su - ${USER} -c "nvm install ${VERSION} > /dev/null 2>&1"
    > ${LOCK}
}

function extras()
{
    echo " - Installing extra tools..."

    LOCK=/tmp/lock.node.extras
    [ -f ${LOCK} ] && return

    PACKAGES="
        npm-check-updates
        http-server
        chupakabra
        node-cpf-cli
        yarn
        uuid
    "

    for PACKAGE in ${PACKAGES}
    do
        sudo su - ${USER} -c "npm install --ignore-scripts -g ${PACKAGE} > /dev/null 2>&1"
    done;

    > ${LOCK}
}

function main()
{
    echo "Installing Node.js development scenario"

    nvmTool
    node
    extras

    echo ""
    echo "Done!"
}

base
main
