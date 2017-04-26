#!/usr/bin/env bash
#
# dynoptparse.sh
# Copyright (C) 2017 Danny Berkowitz <dwowitz@gmail.com>
#
###

### Description ###
# 
# This will parse and validate commandline arguments passed to a bash script.
# If the argument is a valid option, ie. defined in the options array,
# a function of the same name will be executed with the options argument 
# as the functions argument (might ditch the execution part and let the 
# caller script decide what to do with the options.)
# Also generate help messages given an associative array of options
# as keys and descriptions as values.
# 
###

### ISSUES ###
#
# All options must have a unique first letter because short options
# use the first letter of the long option (probably not going to change this).
#
# Each option can only handle 1 argument (fixable, just not sure how yet).
#
# Help text is not properly aligned (fuck it... for now).
#
###

### Example Usage ###
#
# From some other script,
#   . dynoptparse.sh
#   options+=(["my_option:R"]="I just added a required option.")
#   my_option()
#   {
#     echo "Hello, you called my_option because I told you to! HAH!"
#   }
#   parse_opts $@
#
###

ORIGIFS="$IFS"

# Define options and descriptions.
declare -A options=(
    ["help"]="   display this help and exit."
    ["verbose"]="I don't do anything yet."
)

# Usage info
help()
{
    IFS="$ORIGIFS"
    echo -e "\nUsage: ${0##*/} [--option ARGUMENT] [-o ARGUMENT]..."
    for opt in ${!options[@]}; do
        IFS=$':'
        read -r o required <<< "$opt"
        if [ "$required" == "R" ]; then
            echo "    -${o:0:1}|--${o}    ${options[$opt]} (required)"
        else
            echo "    -${o:0:1}|--${o}    ${options[$opt]}"
        fi
        IFS="$ORIGIFS"
    done
    exit 0
}

# If option is passed with no argument, complain and exit with error code.
arg_required()
{
    if [ -z "$2" ]; then
        echo "Option \"$1\" requires an argument."
        help
        exit 1
    else
        true
    fi
}

# If option is required, loops through arguments to make sure it exists.
check_required()
{
    # Make sure IFS is set to its original value.
    IFS="$ORIGIFS"
    # Loop through options
    for opt in ${!options[@]}; do
        # Set $IFS to "|" so we can check for required options.
        IFS=$':'
        read -r o required <<< "$opt"
        # Return IFS to its original value.
        IFS="$ORIGIFS"
        # If option is required, make sure it's an argument.
        if [ "$required" == "R" ]; then
            for arg in "$@"; do
                if [ "--${o}" == "$arg" ] || [ "-${o:0:1}" == "$arg" ]; then
                    req_opt="true"
                    #echo "Found required option \"$o\""
                fi
            done

            if [ "$req_opt" != "true" ]; then
                echo "Option \"--${o}\" must be set."
                opterr="1"
            fi
            unset -v req_opt
        fi
    done
    if [ "$opterr" == "1" ]; then
        help
        exit 1
    fi
}

# main-ish
parse_opts()
{
    check_required $@
    # Create associative array to hold verified options and their arguments.
    declare -A verified
    # Loop through command line arguments.
    for arg in "$@"; do
        # For each command line argument, check if it begins with "-" or "--".
        if [ "${arg:0:2}" == "--" ] || [ "${arg:0:1}" == "-" ]; then
            for opt in ${!options[@]}; do
                # Add "." to $IFS so we can separate the option from its flag.
                IFS=$':'
                read -r o required <<< "$opt"
                # If -h/--help, execute before any other options.
                if [ "$arg" == "--help" ] || [ "$arg" == "-h" ]; then
                    help
                # If argument is an option, make sure it's valid.
                elif [ "$arg" == "--${o}" ] || [ "$arg" == "-${o:0:1}" ]; then
                    verified_bool="true"
                    verified+=(["$o"]="$2")
                    #echo "$o : ${verified["$o"]}"
                fi
                IFS="$ORIGIFS"
            done
            if [ "$verified_bool" != "true" ]; then
                # If option is not valid, complain and exit with error code.
                echo -e "$arg is an invalid option."
                help
                exit 1
            fi
            # Unset validation variable.
            unset -v verified_bool
        fi
        # Go to next argument.
        shift
    done
    for v1 in ${!verified[@]}; do
        v2=${verified["$v1"]}
        $v1 $v2
    done
}
