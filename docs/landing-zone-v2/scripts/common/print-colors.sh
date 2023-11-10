#!/bin/bash

# this script is meant to be sourced from other scripts to output text in color
# the color codes are between '\033[' and 'm'
# https://linuxhandbook.com/change-echo-output-color/

print_divider() {
  lightpurple='\033[1;35m'
  nocolor='\033[0m'
  echo -e "\n${lightpurple}####################  ${1}  ####################${nocolor}\n"
}

print_info() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "\n${lightcyan}##INFO - ${1}${nocolor}\n"
}

print_warning() {
  yellow='\033[1;33m'
  nocolor='\033[0m'
  echo -e "\n${yellow}##WARNING - ${1}${nocolor}\n"
}

print_error() {
  lightred='\033[1;31m'
  nocolor='\033[0m'
  echo -e "\n${lightred}##ERROR - ${1}${nocolor}\n"
}

print_success() {
  lightgreen='\033[1;32m'
  nocolor='\033[0m'
  echo -e "\n${lightgreen}##SUCCESS - ${1}${nocolor}\n"
}
