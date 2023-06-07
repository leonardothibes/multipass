#!/bin/bash

echo "Installing base development scenario..."
HERE=$(dirname $0)

for DIR in $(ls ${HERE}/scripts)
do
    SCRIPT="${HERE}/scripts/${DIR}/run.sh"
    chmod 755 ${SCRIPT}
    sh ${SCRIPT}
done
