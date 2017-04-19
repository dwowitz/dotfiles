#!/usr/bin/env bash

declare -A colors=(
[red01]="#EC4773"
[red02]="#F26B8F"
[red03]="#F798B2"
[blue01]="#5590c5"
[blue02]="#7CAEDB"
[blue03]="#AFD0EE"
[purple01]="#9665D0"
[purple02]="#B58EE4"
[purple03]="#D8C1F4"
[brown01]="#d3a668"
[brown02]="#FBD6A3"
[brown03]="#FFE9CB"
[black03]="#3d3b45"
[white01]="#605e66"
[white03]="#cac9cc"
)

# Default colorschemes (must be included)
read -r -d '' STS <<EOF
static  const  char  *colors[][3]    =  {
    /*               fg        bg        border                   */
    [SchemeNorm] = { white01,  black03,  black03  },  /*  \\\x01  */
    [SchemeSel]  = { white03,  black03,  black03  },  /*  \\\x02  */
    [SchemeUrg]  = { red01,    black03,  black03  },  /*  \\\x03  */
    /* Color Combos */
EOF


raw_list()
{
    n=4
    for c1 in ${!colors[@]}; do
        for c2 in ${!colors[@]}; do
            hexnum=$( printf "%02X" ${n} )
            if [ $c1 != $c2 ] && ([ $c1 == "black03" ] || [ $c2 == "black03" ]); then
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
        colordef+="static const char ${c}[] = \"${colors[$c]}\";\n"
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

