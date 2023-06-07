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

function php()
{
    export DEBIAN_FRONTEND=noninteractive
    VERSION=7.4

    echo " - Installing PHP ${VERSION}..."

    LOCK=/tmp/lock.php.${VERSION}
    [ -f ${LOCK} ] && return

    sudo apt install -y software-properties-common > /dev/null 2>&1
    sudo add-apt-repository -y ppa:ondrej/php      > /dev/null 2>&1
    sudo apt update                                > /dev/null 2>&1

    sudo apt install -y php${VERSION}      \
                    php${VERSION}-curl     \
                    php${VERSION}-gd       \
                    php${VERSION}-ldap     \
                    php${VERSION}-mbstring \
                    php${VERSION}-mysql    \
                    php${VERSION}-pgsql    \
                    php${VERSION}-sybase   \
                    php${VERSION}-sqlite3  \
                    php${VERSION}-intl     \
                    php${VERSION}-xml      \
                    php${VERSION}-dev      \
                    php${VERSION}-xdebug   \
    > /dev/null 2>&1

    sudo curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/scripts/09-php/confs/php.ini      -o /etc/php/${VERSION}/cli
    sudo curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/scripts/09-php/confs/xdebug.ini   -o /etc/php/${VERSION}/mods-available
    sudo curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/scripts/09-php/confs/freetds.conf -o /etc/freetds/freetds.conf

    sudo ln -sf /etc/php/${VERSION}/cli/php.ini /etc/php.ini
    sudo ln -sf /usr/bin/php${VERSION} /etc/alternatives/php

    > ${LOCK}
}

function composer()
{
    echo " - Installing Composer..."

    LOCK=/tmp/lock.php.composer
    [ -f ${LOCK} ] && return

    sudo curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/scripts/09-php/bin/composer -o /usr/local/bin/composer
    sudo chmod 755 /usr/local/bin/composer
    sudo composer self-update > /dev/null 2>&1

    > ${LOCK}
}

function extras()
{
    echo " - Installing Extras..."

    LOCK=/tmp/lock.php.extras
    [ -f ${LOCK} ] && return

    sudo curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/scripts/09-php/bin/md5.php -o /usr/local/bin/md5
    sudo chmod 755 /usr/local/bin/md5

    sudo curl -s https://raw.githubusercontent.com/leonardothibes/workstation/master/scripts/09-php/bin/sha1.php -o /usr/local/bin/sha1
    sudo chmod 755 /usr/local/bin/sha1

    > ${LOCK}
}

function main()
{
    clear
    echo "Installing PHP-7.4 development scenario"
    echo ""

    download
    base
    php
    composer
    extras

    echo ""
    echo "Done!"
}

main
