#!/bin/bash

function help() {
    echo "update trigger helper"
    echo "usage: update-helper [options]"
    echo ""
    echo "options:"
    echo " --reexec -r: Will run daemon-reexec instead of daemon-reload (only used with systemctl)"
    echo " --no-block -n: Will run the update hooks in the background"
    echo " --help -h: display this menu"
    echo ""
}

update() {
    local block_flag=""
    local reexec=

    for var in "$@"; do
        case "$var" in
            "--help"|"-h")
                help
                exit 0
                ;;
            "--no-block"|"-n")
                block_flag="--no-block"
                ;;
            "--reexec"|"-r")
                reexec=1
                ;;
            *)
                help
                exit -1
                ;;
        esac
    done

    systemctl &> /dev/null
    if [ $? -eq 0 ]; then
        if [ ! -z "${reexec}" ]; then
            systemctl daemon-reexec
        else
            systemctl daemon-reload
        fi
        systemctl restart "${block_flag}" update-triggers.target
    else # Not using systemd as init
        if [ -z "${block_flag}" ]; then
            /usr/libexec/update-trigger.sh
        else
            /usr/libexec/update-trigger.sh &
        fi
    fi
}

update "$@"
