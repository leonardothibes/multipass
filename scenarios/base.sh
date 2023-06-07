#!/bin/bash

function update()
{
    echo " - Updating package list..."

    LOCK=/tmp/lock.base.update
    [ -f ${LOCK} ] && return

    sudo apt update > /dev/null 2>&1
    > ${LOCK}
}

function utils()
{
    echo " - Installing Utils..."

    LOCK=/tmp/lock.base.utils
    [ -f ${LOCK} ] && return

    sudo apt install -y git-flow \
                        curl     \
                        wget     \
                        make     \
                        zip      \
    > /dev/null 2>&1
    > ${LOCK}
}

function zsh()
{
    echo " - Installing ZSH..."

    LOCK=/tmp/lock.base.zsh
    [ -f ${LOCK} ] && return

    sudo apt install -y zsh fonts-powerline                                    > /dev/null 2>&1
    git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh > /dev/null 2>&1

    mkdir -p  ${HOME}/.oh-my-zsh/cache
    chmod 755 ${HOME}/.oh-my-zsh/oh-my-zsh.sh

    curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/scripts/17-zsh/confs/.zshrc -o ${HOME}/.zshrc
    > ${LOCK}
}

function base()
{
    echo "Installing Base development scenario"

    update
    utils
    zsh

    echo ""
}
