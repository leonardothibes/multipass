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

    sudo apt-get install -y git-flow \
                            curl     \
                            wget     \
                            make     \
                            zip      \
                            unzip    \
    > /dev/null 2>&1
    > ${LOCK}
}

function zsh()
{
    echo " - Installing ZSH..."

    LOCK=/tmp/lock.base.zsh
    [ -f ${LOCK} ] && return

    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get install -y zsh fonts-powerline > /dev/null 2>&1

    INSTALL=/etc/skel/.oh-my-zsh
    sudo git clone https://github.com/robbyrussell/oh-my-zsh.git ${INSTALL} > /dev/null 2>&1
    sudo curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/core/scripts/19-zsh/confs/.zshrc -o /etc/skel/.zshrc

    sudo mkdir -p  ${INSTALL}/cache
    sudo chmod 755 ${INSTALL}/oh-my-zsh.sh

    if [ -d /home/ubuntu ]; then
        sudo cp -Rf ${INSTALL} /home/ubuntu/.oh-my-zsh
        sudo cp -Rf /etc/skel/.zshrc /home/ubuntu
        sudo chown -R ubuntu:ubuntu /home/ubuntu
    fi

    > ${LOCK}
}

function vim()
{
    echo " - Installing VIM..."

    LOCK=/tmp/lock.base.vim
    [ -f ${LOCK} ] && return

    sudo apt-get install -y vim > /dev/null 2>&1
    sudo curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/core/scripts/06-vim/confs/vimrc -o /etc/vim/vimrc
    sudo chmod 644 /etc/vim/vimrc

    > ${LOCK}
}

function gitName()
{
    LOCK=/tmp/lock.base.git.name
    [ -f ${LOCK} ] && return

    read -p "Informe o nome usado no GIT: " NAME
    if [ "$NAME" != "" ]; then
        git config --global user.name "$NAME"
    fi

    > ${LOCK}
}

function gitEmail()
{
    LOCK=/tmp/lock.base.git.email
    [ -f ${LOCK} ] && return

    read -p "Informe o e-mail usado no GIT: " EMAIL
    if [ "$EMAIL" != "" ]; then
        git config --global user.email "$EMAIL"
    fi

    > ${LOCK}
}

function gitConfig()
{
    gitName
    gitEmail
}

function base()
{
    update
    utils
    zsh
    vim
}

function after()
{
    echo ""
    echo "Extra configurations"
    echo ""

    gitConfig
    echo "Already configured"
}
