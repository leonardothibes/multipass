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

function main()
{
    clear
    echo "Installing Bash development scenario"
    echo ""

    download
    base

    echo ""
    echo "Done!"
}

main
