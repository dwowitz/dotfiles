#!/usr/bin/env bash
#
# dynoptest01.sh
# Copyright (C) 2017 Danny Berkowitz <dwowitz@gmail.com>
#
# Distributed under terms of the MIT license.
#

dir=$(cd -P $(dirname $BASH_SOURCE[0]) && pwd)

. $dir/../lib/sh/dynoptparse.sh
options+=(["my_option:R"]="I just added a required option.")
my_option()
{
	echo "Hello, you called my_option because I told you to..."
	echo "HAHaha, I WIN!"
}
parse_opts $@

