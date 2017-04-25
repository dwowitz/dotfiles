#! /bin/bash
#
# colors.bash
# Copyright (C) 2017 Danny Berkowitz <dwowitz@gmail.com>
#
# Distributed under terms of the MIT license.
#

# Escape variable
ESC=$(printf "\e")
# Color variables for prompt
TBOLD="\[${ESC}[1m\]"
TNORM="\[${ESC}[0m\]"
fg_R="\[${ESC}[31m\]"
fg_G="\[${ESC}[32m\]"
fg_Y="\[${ESC}[33m\]"
fg_B="\[${ESC}[34m\]"
fg_M="\[${ESC}[35m\]"
fg_C="\[${ESC}[36m\]"
fg_W="\[${ESC}[37m\]"

