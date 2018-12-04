#!/bin/bash

[ "$1" ] || exit
script=$1

BASE_URL="https://raw.githubusercontent.com/mikakatua/linux-fun/master/labs"

exec &> /tmp/${script}.log
bash <(curl -s $BASE_URL/${script}.sh)
