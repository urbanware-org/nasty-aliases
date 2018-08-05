#!/bin/bash

# ============================================================================
# nasty-aliases - Nasty shell aliases check script
# Copyright (C) 2018 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/nasty-aliases
# GitLab: https://gitlab.com/urbanware-org/nasty-aliases
# ============================================================================

version="1.1.7"

check_file() {

    filename="$1"
    suspicious=0

    for command in $check_for; do
        output=$(grep "^alias.*$command=" $filename)
        if [ $? -eq 0 ]; then
            echo "$output" >> $temp_file
            suspicious=1
        fi
    done

    if [ $suspicious -eq 1 ]; then
        echo "File '$filename':" >> $log_file
        while read line; do
            echo "  - $line" >> $log_file
        done < $temp_file
        echo >> $log_file
    fi

    rm -f $temp_file

}

nasty_aliases() {

    if [ $# -gt 1 ]; then
        echo "error: Multiple commands must be enclosed with quotes"
        return 1
    fi

    check_for="$1"
    if [ -z "$check_for" ]; then
        # Fallback if no commands have been passed via command-line argument.
        # You can manually add one or more commands (separated by spaces)
        # below. However, this fallback will be ignored if a command-line
        # argument was given.
        check_for="su sudo"
    fi

    log_file="/tmp/nasty_aliases.log"
    temp_file="/tmp/nasty_aliases.tmp"
    rm -f $log_file $temp_file

    check_file /etc/bashrc
    check_file ~/.bashrc

    if [ -f $log_file ]; then
        echo
        echo "Suspicious aliases detected!"
        echo
        echo "Please check the following command aliases. Maybe someone is"\
             "trying something"
        echo "nasty on your system."
        echo
        cat $log_file
        rm -f $log_file
        return 2
    fi

}

if [ $# -gt 0 ]; then
    nasty_aliases $@
fi

# EOF
