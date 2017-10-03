#!/bin/bash

if [ -x /usr/bin/clrtrust ]; then
    /usr/bin/clrtrust generate
else
    rm -fr /var/cache/ca-certs
    mkdir -p /var/cache/ca-certs
    cp -r --preserve=mode,links /usr/share/ca-certs/.prebuilt-store/* /var/cache/ca-certs
fi
