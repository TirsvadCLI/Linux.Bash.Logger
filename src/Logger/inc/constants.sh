#!/bin/bash

## @brief string version
declare -g -r TCLI_LINUX_BASH_LOGGER="0.3.3"
## @brief bool if warning have been triggered
declare -g -i TCLI_LINUX_BASH_LOGGER_INFOSCREEN_WARN=0
## @brief string internal field separator
declare -g IFS=$'\n\t'
## @brief string color no color
declare -g -r TCLI_LINUX_BASH_LOGGER_NC='\033[0m' # No Color
## @brief string color red
declare -g -r TCLI_LINUX_BASH_LOGGER_RED='\033[0;31m'
## @brief string color green
declare -g -r TCLI_LINUX_BASH_LOGGER_GREEN='\033[0;32m'
## @brief string color brown
declare -g -r TCLI_LINUX_BASH_LOGGER_BROWN='\033[0;33m'
## @brief string color blue
declare -g -r TCLI_LINUX_BASH_LOGGER_BLUE='\033[0;34m'
## @brief string color yellow
declare -g -r TCLI_LINUX_BASH_LOGGER_YELLOW='\033[1;33m'
## @brief string color white
declare -g -r TCLI_LINUX_BASH_LOGGER_WHITE='\033[0;37m'
## @brief back to line
declare -g -r TCLI_LINUX_BASH_BACK_TO_LINE='\r\033[1C'
## @brief log to file
declare -g -i TCLI_LINUX_BASH_LOGGER_TO_FILE=1
