#!/bin/bash

if [ -e /var/cache/locale/locale-archive ]; then
    exit 0
fi

if [ -x /usr/bin/localdef ]; then
    /usr/bin/localedef -i en_US -c -f UTF-8 en_US.UTF-8
fi
