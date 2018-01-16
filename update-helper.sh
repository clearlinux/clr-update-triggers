#!/bin/bash

function help() {
    echo "update trigger helper"
    echo "usage: update-helper [options] [PATH]"
    echo ""
    echo " PATH: Run update scripts in a chroot located at PATH (does not use systemd)"
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
    local prefix="/"

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
                if [ "$prefix" != "/" ]; then
                    help
                    exit -1
                fi
                prefix="$var"
                ;;
        esac
    done

    systemctl &> /dev/null
    # Check if systemd is init and not being run for a chroot update
    if [ $? -eq 0 ] && [ "${prefix}" = "/" ]; then
        if [ ! -z "${reexec}" ]; then
            systemctl daemon-reexec
        else
            systemctl daemon-reload
        fi
        systemctl restart "${block_flag}" update-triggers.target
    else # Not using systemd as init, run the trigger scripts
        if [ -z "${block_flag}" ]; then
            "${prefix}/usr/libexec/updater/update-trigger.sh" "${prefix}"
        else
            "${prefix}/usr/libexec/updater/update-trigger.sh" "${prefix}" &
        fi
    fi
}

update "$@"
