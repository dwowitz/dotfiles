#!/usr/bin/env bash

# Color naming scheme:
#
# dBk = Dark Black
# lBk = Light Black
# dB = Dark Blue
# lY = Light Yellow ... etc...
# Only white and Black use 2 letters.
# All others only use 1, plus d or l.

declare -A colors=(
    [dBk]="4d5061"
    [dR]="ea526f"
#    [dG]=""
    [dY]="fed766"
    [dB]="5c80bc"
#    [dM]=""
#    [dC]=""
#    [dWh]=""
#    [lBk]=""
#    [lR]=""
#    [lG]=""
#    [lY]=""
#    [lB]=""
#    [lM]=""
#    [lC]="99b2dd"
    [lWh]="cdd1c4"
)

# Default colorschemes (must be included)
read -r -d '' STS <<EOF
static  const  char  *colors[][3]    =  {
    /*               fg    bg    border             */
    [SchemeNorm] = { lWh,  dBk,  dBk  },  /*  \\\x01  */
    [SchemeSel]  = { dY,   dBk,  dB   },  /*  \\\x02  */
    [SchemeUrg]  = { dY,   dBk,  dY   },  /*  \\\x03  */
    /* Color Combos */
EOF


raw_list()
{
    n=4
    for c1 in ${!colors[@]}; do
        for c2 in ${!colors[@]}; do
            hexnum=$( printf "%02X" ${n} )
            if [ $c1 != $c2 ]; then
                lsit+="$c1 $c2 $hexnum\n"
                n=$(( $n + 1 ))
            fi
        done
    done
    echo -e $lsit | awk '{ print $1, $2, $3 }' | head -n -1
}

show_enum()
{
    echo -e "enum {\n    SchemeNorm, SchemeSel, SchemeUrg, "
    raw_list | awk '{ print $1 "_" $2", "}' | tr -d '\n' | sed 's/^/    /'
    echo -e "\n};"
}

show_colors()
{
    for c in ${!colors[@]}; do
        colordef+="static const char ${c}[] = \"#${colors[$c]}\";\n"
    done
    echo -e "$colordef" | column -t
}

show_combos()
{
    echo -e "$STS"
    IFS=$'\n'
    for l in `raw_list`; do
        a+=$(echo -e $l | awk '{ print "["$1"_"$2"] = { "$1", "$2", "$2" }, /* \\\\x"$3" */\\n"}')
    done
    #echo -e $a | grep -Ev 'Yellow|Green|lightBlue' | column -t | sed 's/^/    /g'
    echo -e $a | column -t | sed 's/^/    /g'
    echo -e "};"
}

gen_shelper()
{
    IFS=$'\n'
    for l in `raw_list`; do
        echo -e $l | awk '{ print $1"_"$2"=\"\\x"$3"\""}' | tr "\"" "\'"
    done
}

case $1 in
    "genconfig")
        show_enum
        show_colors
        show_combos
        ;;
    "raw")
        raw_list
        ;;
    "enum")
        show_enum
        ;;
    "colors")
        show_colors
        ;;
    "combos")
        show_combos
        ;;
    "helper")
        gen_shelper
        ;;
esac

