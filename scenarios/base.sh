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

    DIR=ubuntu
    sudo apt install -y zsh fonts-powerline                                    > /dev/null 2>&1
    git clone https://github.com/robbyrussell/oh-my-zsh.git ${DIR}/.oh-my-zsh > /dev/null 2>&1

    mkdir -p  ${DIR}/.oh-my-zsh/cache
    chmod 755 ${DIR}/.oh-my-zsh/oh-my-zsh.sh

    curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/scripts/19-zsh/confs/.zshrc -o ${DIR}/.zshrc
    > ${LOCK}
}

function vim()
{
    echo " - Installing VIM..."

    LOCK=/tmp/lock.base.vim
    [ -f ${LOCK} ] && return

    sudo apt install -y vim > /dev/null 2>&1
    sudo curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/scripts/06-vim/confs/vimrc -o /etc/vim/vimrc
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
