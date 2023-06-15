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

    [ -d /opt/nvm ] || sudo git clone https://github.com/nvm-sh/nvm.git /opt/nvm > /dev/null 2>&1
    sudo chmod 777 /opt/nvm

    [ -d /usr/local/nvm  ] || sudo mkdir /usr/local/nvm
    [ -d /usr/local/node ] || sudo mkdir /usr/local/node
    sudo chmod 777 /usr/local/nvm /usr/local/node

    [ -f /etc/profile.d/nvm.sh ] || sudo touch /etc/profile.d/nvm.sh
    sudo chmod 666 /etc/profile.d/nvm.sh

    sudo echo 'export NVM_DIR=/usr/local/nvm'            > /etc/profile.d/nvm.sh
    sudo echo 'source /opt/nvm/nvm.sh'                  >> /etc/profile.d/nvm.sh
    sudo echo ''                                        >> /etc/profile.d/nvm.sh
    sudo echo 'export PATH="/usr/local/node/bin:$PATH"' >> /etc/profile.d/nvm.sh
    sudo chmod 644 /etc/profile.d/nvm.sh

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
    after

    echo ""
    echo "Done!"
}

main
