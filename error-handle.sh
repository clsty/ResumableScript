#!/bin/bash

# This is another way to do error-handling other than the function v().
# Add the following lines to the top of your script.
set -e
function try { "$@" || sleep 0; }
function aaa { while true;do if "$@";then break;else echo "[$0]: Retrying \"$@\"";sleep 1;fi;done; }






################################## Usage example ##################################
t=/tmp/testdir;mkdir -p ${t}{2,3}

########## eg 1
echo -e "\e[46m[$0]: 1. Now executing \"mkdir ${t}1\".\e[0m"
echo -e "\e[44m[$0]: This command will fail when you run this script twice,\e[0m"
echo -e "\e[44m[$0]: and when it fail, the script will exit because of \"set -e\".\e[0m"
echo -e "\e[44m[$0]: Delete the folder ${t}1 manually to reset.\e[0m";sleep 5

mkdir ${t}1

########## eg 2
echo -e "\e[46m[$0]: 2. Now executing \"try mkdir ${t}2\".\e[0m"
echo -e "\e[44m[$0]: This command will fail, but will NOT make the script exit even when \"set -e\", because \"try()\" catches its stderr.\e[0m";sleep 5

try mkdir ${t}2

########## eg 3
echo -e "\e[46m[$0]: 3. Now executing \"aaa mkdir ${t}3\".\e[0m"
echo -e "\e[44m[$0]: This command will fail, but will repeat again and again until success or being stopped forcely, because of \"aaa()\".\e[0m"
echo -e "\e[44m[$0]: To let it succeed at least once, you need to delete folder ${t}3 manually now.\e[0m";sleep 5

aaa mkdir ${t}3

