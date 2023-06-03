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
# screen color
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
## All error go to log file
## Output to file example
## printf "this output is visible" >&3
## @param log file full path
tcli_logger_init() {
  local _file=${1-my.log}
  local _dir
  _dir=$(dirname "${1}")
	[ ! -d ${_dir} ] && mkdir $_dir || rm -f ${1}
  exec 3>&1 4>&2
  exec 3>$_file 2>&3
  printf "Logger loaded\n" >&3
}

## @fn tcli_logger_infoscreen()
## @details
## **Info of the process step [ ... ]**
tcli_logger_infoscreen() {
	printf $(printf "[......] ${TCLI_LOGGER_BROWN}$1 ${TCLI_LOGGER_NC}$2$n")
}

## @fn tcli_logger_infoscreenDone()
## @details
## **Info of the process step [ DONE ]**
tcli_logger_infoscreenDone() {
	[ ${TCLI_LOGGER_INFOSCREEN_WARN} == 1 ] && TCLI_LOGGER_INFOSCREEN_WARN=0 || printf "\r\033[1C${TCLI_LOGGER_GREEN} DONE ${TCLI_LOGGER_NC}"
	printf "\r\033[80C\n"
}

## @fn tcli_logger_infoscreenFailed()
## @details
## **Info of the process step [ FAILED ]**
## @param error message part 1 red color
## @param error message part 2 blue color
## @param error message part 3 red color
tcli_logger_infoscreenFailed() {
  local _errormsg="${1:-} ${2:-} ${3:-}"
	[ ${TCLI_LOGGER_INFOSCREEN_WARN} == 1 ] && TCLI_LOGGER_INFOSCREEN_WARN=0
	printf "\r\033[1C${TCLI_LOGGER_RED}FAILED${TCLI_LOGGER_NC}\n"
	# [ ${1:-} ] && printf "${TCLI_LOGGER_RED}${1}"
	# [ ${2:-} ] && printf " ${TCLI_LOGGER_BLUE}${2}"
	# [ ${3:-} ] && printf " ${TCLI_LOGGER_RED}${3}"
	# printf "${TCLI_LOGGER_NC}\n"
  [ ! -z "${_errormsg:-}" ] && printf "${_errormsg}" >&2
}

## @fn tcli_logger_infoscreenFailedExit()
## @details
## **Info of the process step [ FAILED ]**
## Then it will exit with a error code
## @param error message part 1 red color
## @param error message part 2 blue color
## @param error message part 3 red color
## @param exit code (default is 1)
tcli_logger_infoscreenFailedExit() {
  local -i _errorCode=${1:-1}
  tcli_logger_infoscreenFailed "${1:-}" "${2:-}" "${3:-}"
	exit $_errorCode
}

## @fn tcli_logger_infoscreenWarn()
## @details
## **Info of the process step [ FAILED ]**
## Then exit with a error code
tcli_logger_infoscreenWarn() {
	printf "\r\033[1C${TCLI_LOGGER_YELLOW} WARN ${TCLI_LOGGER_NC}"
	TCLI_LOGGER_INFOSCREEN_WARN=1
}

## @fn tcli_logger_infoscreenStatus()
tcli_logger_infoscreenStatus() {
    if [ $1 != "0" ]; then
        tcli_logger_infoscreenFailed
    else
        tcli_logger_infoscreenDone
    fi
}

## @fn tcli_logger_errorCheck()
## @details
## **TODO**
tcli_logger_errorCheck() {
	if [ $? -eq 0 ]; then
		printf "${TCLI_LOGGER_RED}An error has occured.${TCLI_LOGGER_NC}"
		# read -p "Press enter or space to ignore it. Press any other key to abort." -n 1 key
		# if [[ $key != "" ]]; then
		# 	exit
		# fi
	fi
}

## @fn tcli_logger_title()
## @details
## **Title**
## Fillerlength value is allways one less than the number of char it start with 0
## @param title
## @param fillerlength with '+' ( default value is 79 which is 80 char )
## @param filler char
tcli_logger_title() {
  local _title=${1:-}
  local -i _fillerlength=${2:-79}
  local _fillerchar=${3:-"+"}
  local -i _n_pad=$(( (${_fillerlength} - ${#_title} - 2) / 2 ))
  local -i _i=$(( $_n_pad * 2 + 2 +${#_title} ))
  printf -- "${_fillerchar}%.0s" $(seq ${_fillerlength})
  printf "\n"
  printf -- "${_fillerchar}%.0s" $(seq ${_n_pad})
  printf $(printf ' %s ' "$_title")
  if [ $(( $_n_pad * 2 + ${#_title} + 2 )) -lt ${_fillerlength} ]; then
    (( _n_pad++ ))
  fi
  printf -- "${_fillerchar}%.0s" $(seq ${_n_pad})
  printf "\n"
  printf -- "${_fillerchar}%.0s" $(seq ${_fillerlength})
  printf "\n"
}
