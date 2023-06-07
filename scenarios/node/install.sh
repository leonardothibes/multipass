#!/bin/bash

echo "Installing Node.js development scenario..."
BASE=$(dirname $0)/../base
REPO=https://github.com/leonardothibes/multipass/archive/refs/heads/feature/node-scenario.zip
TEMP=/tmp

curl -o $REPO $TEMP
