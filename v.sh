#!/usr/bin/env bash
function v() {
  echo -e "\e[34m[$0]: Next command:\e[0m"
  echo -e "\e[32m$@\e[0m"
  execute=true
  if $ask;then
    while true;do
      echo -e "\e[34mExecute the command above? \e[0m"
      echo "  y = Yes"
      echo "  e = Exit now"
      echo "  s = Skip this command (may DISRUPT the normal flow of the script!)"
      echo "  yesforall = Yes and don't ask again (only when you really sure)"
      read -p "Enter here [y/e/s/yesforall]: " p
      case $p in
        [yY]) echo -e "\e[34m[$0]: OK, executing...\e[0m" ;break ;;
        [eE]) echo -e "\e[34m[$0]: Exiting...\e[0m" ;exit ;break ;;
        [sS]) echo -e "\e[34m[$0]: Alright, skipping this one...\e[0m" ;execute=false;break ;;
        "yesforall") echo -e "\e[34m[$0]: Alright, won't ask again. Executing...\e[0m";ask=false ;break ;;
        *) echo -e "\e[31mPlease enter one of [y/e/s/yesforall].\e[0m";;
      esac
    done
  fi
  if $execute;then x "$@";else
    echo -e "\e[33m[$0]: Command \"\e[32m$@\e[33m\" has been skipped by user.\e[0m"
  fi
}
# When use v() for a defined function, use x() INSIDE its definition to catch errors.
function x() {
  while [ $cmdstatus == 1 ] ;do
    echo -e "\e[31m[$0]: Command \"\e[32m$@\e[31m\" has failed."
    echo -e "You may need to resolve the problem manually BEFORE repeating this command.\e[0m"
    echo "  r = Repeat this command (DEFAULT)"
    echo "  e = Exit now"
    echo "  i = Ignore the error and continue this script anyway  (may DISRUPT the normal flow of the script!)"
    read -p "Enter here [R/e/i]: " p
    case $p in
      [iI]) echo -e "\e[34m[$0]: Alright, ignore and continue...\e[0m";cmdstatus=2;;
      [eE]) echo -e "\e[34m[$0]: Alright, will exit.\e[0m";break;;
      *) echo -e "\e[34m[$0]: OK, repeating...\e[0m"
         if "$@";then cmdstatus=0;else cmdstatus=1;fi
         ;;
    esac
  done
  case $cmdstatus in
    0) echo -e "\e[34m[$0]: Command \"\e[32m$@\e[34m\" finished.\e[0m";;
    1) echo -e "\e[31m[$0]: Command \"\e[32m$@\e[31m\" has failed. Exiting...\e[0m";exit 1;;
    2) echo -e "\e[31m[$0]: Command \"\e[32m$@\e[31m\" has failed but ignored by user.\e[0m";;
  esac
}
function showfun() {
  echo -e "\e[34m[$0]: The definition of function \"$1\" is as follows:\e[0m"
  printf "\e[32m"
  type -a $1
  printf "\e[97m"
}

################################## Usage example ##################################
ask=true; mkdir -p /tmp/testdir
echo -e "\e[44m[$0]: The following is an example of the function v().\e[0m"

echo -e "\e[44m[$0]: 1. The following command will succeed as normal.\e[0m"
v echo "Hello world!"

echo -e "\e[44m[$0]: 2. The following command will fail because target directory already exists (created before) and mkdir is used without '-p' flag.\e[0m"
echo -e "\e[44m[$0]: The method to resolve the problem is to execute 'rmdir /tmp/testdir'. \e[0m"
v mkdir /tmp/testdir

echo -e "\e[44m[$0]: Example done.\e[0m"
