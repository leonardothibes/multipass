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

    [ -d /opt/nvm ]        || sudo git clone https://github.com/nvm-sh/nvm.git /opt/nvm > /dev/null 2>&1
    [ -d /usr/local/nvm  ] || sudo mkdir /usr/local/nvm
    [ -d /usr/local/node ] || sudo mkdir /usr/local/node

    [ -f /etc/profile.d/nvm.sh ] || sudo touch /etc/profile.d/nvm.sh
    sudo chmod 666 /etc/profile.d/nvm.sh

    sudo echo 'export NVM_DIR=/usr/local/nvm'             > /etc/profile.d/nvm.sh
    sudo echo 'source /opt/nvm/nvm.sh'                   >> /etc/profile.d/nvm.sh
    sudo echo ''                                         >> /etc/profile.d/nvm.sh
    sudo echo 'export NPM_CONFIG_PREFIX=/usr/local/node' >> /etc/profile.d/nvm.sh
    sudo echo 'export PATH="/usr/local/node/bin:$PATH"'  >> /etc/profile.d/nvm.sh
    sudo chmod 644 /etc/profile.d/nvm.sh

    > ${LOCK}
}

function installNode()
{
    VERSION=$1
    echo " - Installing Node.js ${VERSION}..."

    LOCK=/tmp/lock.node.${VERSION}
    [ -f ${LOCK} ] && return

    HAS=$(which node | wc -l)
    if [ $HAS == "0" ]; then
        source /opt/nvm/nvm.sh
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

    source /opt/nvm/nvm.sh
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
    installNode "16"
    extras
    after

    echo ""
    echo "Done!"
}

main
