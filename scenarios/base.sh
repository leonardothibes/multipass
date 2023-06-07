#!/bin/bash

echo "Installing Base development scenario"

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
    echo " - Installing utils..."

    LOCK=/tmp/lock.base.utils
    [ -f ${LOCK} ] && return

    sudo apt install -y git-flow \
                        make     \
                        zip      \
    > /dev/null 2>&1
    
    > ${LOCK}
}

update
utils