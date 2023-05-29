#!/bin/bash

## @file
## @author Jens Tirsvad Nielsen
## @brief Logger
## @details
## **Logger**
##
## Info to screen
## Log info and error to file

declare -g IFS=$'\n\t'
declare -g TCLI_LOGGER_INFOSCREEN_WARN=0
# screen color output
declare -g -r TCLI_LOGGER_NC='\033[0m' # No Color
declare -g -r TCLI_LOGGER_RED='\033[0;31m'
declare -g -r TCLI_LOGGER_GREEN='\033[0;32m'
declare -g -r TCLI_LOGGER_BROWN='\033[0;33m'
declare -g -r TCLI_LOGGER_BLUE='\033[0;34m'
declare -g -r TCLI_LOGGER_YELLOW='\033[1;33m'
declare -g -r TCLI_LOGGER_WHITE='\033[0;37m'

## @fn tcli_logger_init()
## @details
## **Initial logger**
## All output to file
## output to screen example
## printf "this output is visible" >&3
## @param logfil full path
tcli_logger_init() {
  local _file=${1-}
  local _dir
  _dir=$(dirname "${1}")
	[ ! -d ${_dir} ] && mkdir $_dir || rm -f ${1}
  exec 3>&1 4>&2
  exec 1>$_file 2>&1
  printf "Logger loaded"
}

tcli_logger_infoscreen() {
	printf $(printf "[......] ${TCLI_LOGGER_BROWN}$1 ${TCLI_LOGGER_NC}$2$n") >&3
}

tcli_logger_infoscreenDone() {
	[ ${TCLI_LOGGER_INFOSCREEN_WARN} == 1 ] && TCLI_LOGGER_INFOSCREEN_WARN=0 || printf "\r\033[1C${TCLI_LOGGER_GREEN} DONE ${TCLI_LOGGER_NC}" >&3
	printf "\r\033[80C\n" >&3
}

tcli_logger_infoscreenFailed() {
	[ ${TCLI_LOGGER_INFOSCREEN_WARN} == 1 ] && TCLI_LOGGER_INFOSCREEN_WARN=0
	printf "\r\033[1C${TCLI_LOGGER_RED}FAILED${TCLI_LOGGER_NC}\n" >&3
	[ ${1} ] && printf "${TCLI_LOGGER_RED}${1:-}" >&3
	[ ${2} ] && printf " ${TCLI_LOGGER_BLUE}$2" >&3
	[ ${3} ] && printf " ${TCLI_LOGGER_RED}$3" >&3
	printf "${TCLI_LOGGER_NC}\n" >&3
}

tcli_logger_infoscreenFailedExit() {
	printf "\r\033[1C${TCLI_LOGGER_RED}FAILED${TCLI_LOGGER_NC}\n" >&3
	[ ${1} ] && printf "${TCLI_LOGGER_RED}${1:-}" >&3
	[ ${2} ] && printf " ${TCLI_LOGGER_BLUE}$2" >&3
	[ ${3} ] && printf " ${TCLI_LOGGER_RED}$3" >&3
	printf "${TCLI_LOGGER_NC}\n" >&3
	exit 1
}

tcli_logger_infoscreenWarn() {
	printf "\r\033[1C${TCLI_LOGGER_YELLOW} WARN ${TCLI_LOGGER_NC}" >&3
	TCLI_LOGGER_INFOSCREEN_WARN=1
}

tcli_logger_infoscreenStatus() {
    if [ $1 != "0" ]; then
        tcli_logger_infoscreenFailed
    else
        tcli_logger_infoscreenDone
    fi
}

tcli_logger_errorCheck() {
	if [ "$?" = "0" ]; then
		printf "${TCLI_LOGGER_RED}An error has occured.${TCLI_LOGGER_NC}" >&3
		# read -p "Press enter or space to ignore it. Press any other key to abort." -n 1 key
		# if [[ $key != "" ]]; then
		# 	exit
		# fi
	fi
}