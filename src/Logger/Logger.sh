#!/bin/bash

## @file logger.sh
## @brief Logger for screen and file
## @details
## This is a shell script designed to handle logging for various processes. It can log information to the screen and redirect logs to a specified file, allowing for better error tracking and process monitoring.
##
## @author Jens Tirsvad Nielsen
## @date May 2023

declare -g -r TCLI_LINUX_LOGGER_SCRIPTDIR="$(dirname "$(realpath "${BASH_SOURCE}")")"

## @brief string for check if script is sourced
declare -g -r TCLI_LINUX_LOGGER
## @brief string version
declare -g TCLI_LINUX_LOGGER_VERSION="1.0.0"
## @brief string internal field separator
declare -g IFS=$'\n\t'
## @brief bool if warning have been triggered
declare -g TCLI_LINUX_LOGGER_INFOSCREEN_WARN=0
## @brief string color no color
declare -g -r TCLI_LINUX_LOGGER_NC='\033[0m' # No Color
## @brief string color red
declare -g -r TCLI_LINUX_LOGGER_RED='\033[0;31m'
## @brief string color green
declare -g -r TCLI_LINUX_LOGGER_GREEN='\033[0;32m'
## @brief string color brown
declare -g -r TCLI_LINUX_LOGGER_BROWN='\033[0;33m'
## @brief string color blue
declare -g -r TCLI_LINUX_LOGGER_BLUE='\033[0;34m'
## @brief string color yellow
declare -g -r TCLI_LINUX_LOGGER_YELLOW='\033[1;33m'
## @brief string color white
declare -g -r TCLI_LINUX_LOGGER_WHITE='\033[0;37m'

## @fn tcli_linux_logger_init()
## @details
## **Initial logger**
## All error go to log file
## Output to file example
## printf "this output is visible" >&3
## @param string full path of the log file
tcli_linux_logger_init() {
  local _file=${1-my.log}
  local _dir
  _dir=$(dirname "${1}")
	[ ! -d ${_dir} ] && mkdir $_dir || rm -f ${1}
  exec 3>&1 4>&2
  exec 3>$_file 2>&3
  tcli_linux_logger_file_info "Loaded" "Logger $TCLI_LINUX_LOGGER_VERSION"
}

## @fn tcli_linux_logger_infoscreen()
## @details
## **Info of the process step [ ... ]**
tcli_linux_logger_infoscreen() {
	printf $(printf "[......] ${TCLI_LINUX_LOGGER_BROWN}$1 ${TCLI_LINUX_LOGGER_NC}$2$n")
}

## @fn tcli_linux_logger_infoscreenDone()
## @details
## **Info of the process step [ DONE ]**
tcli_linux_logger_infoscreenDone() {
	[ ${TCLI_LINUX_LOGGER_INFOSCREEN_WARN} == 1 ] && TCLI_LINUX_LOGGER_INFOSCREEN_WARN=0 || printf "\r\033[1C${TCLI_LINUX_LOGGER_GREEN} DONE ${TCLI_LINUX_LOGGER_NC}"
	printf "\r\033[80C\n"
}

## @fn tcli_linux_logger_infoscreenFailed()
## @details
## **Info of the process step [ FAILED ]**
## @param string error message part 1 red color
## @param string error message part 2 blue color
## @param string error message part 3 red color
## @param string function or other notice in front of message
tcli_linux_logger_infoscreenFailed() {
  local -a _errormsg
	# ="${1:-} ${2:-} ${3:-}"
	[ ${1:-} ] && _errormsg=($1)
	[ ${2:-} ] && _errormsg+=($2)
	[ ${3:-} ] && _errormsg+=($3)
	[ ${TCLI_LINUX_LOGGER_INFOSCREEN_WARN} == 1 ] && TCLI_LINUX_LOGGER_INFOSCREEN_WARN=0
	printf "\r\033[1C${TCLI_LINUX_LOGGER_RED}FAILED${TCLI_LINUX_LOGGER_NC}\n"
	tcli_linux_logger_file_error $(echo ${_errormsg[@]}) ${4:-}
}

## @fn tcli_linux_logger_infoscreenFailedExit()
## @details
## **Info of the process step [ FAILED ]**
## Then it will exit with a error code
## @param string error message part 1 red color
## @param string error message part 2 blue color
## @param string error message part 3 red color
## @param interger exit code (default is 1)
## @param string error cause
tcli_linux_logger_infoscreenFailedExit() {
  tcli_linux_logger_infoscreenFailed "${1:-}" "${2:-}" "${3:-}" "${5:-}"
	[ ${4:-} ] && printf "${TCLI_LINUX_LOGGER_RED}${1} : "
	[ ${1:-} ] && printf "${TCLI_LINUX_LOGGER_RED}${1}"
	[ ${2:-} ] && printf " ${TCLI_LINUX_LOGGER_BLUE}${2}"
	[ ${3:-} ] && printf " ${TCLI_LINUX_LOGGER_RED}${3}"
	printf "${TCLI_LINUX_LOGGER_NC}\n"
	exit ${4:-1}
}

## @fn tcli_linux_logger_infoscreenWarn()
## @details
## **Info of the process step [ FAILED ]**
## Then exit with a error code
tcli_linux_logger_infoscreenWarn() {
	printf "\r\033[1C${TCLI_LINUX_LOGGER_YELLOW} WARN ${TCLI_LINUX_LOGGER_NC}"
	TCLI_LINUX_LOGGER_INFOSCREEN_WARN=1
}

## @fn tcli_linux_logger_infoscreenStatus()
tcli_linux_logger_infoscreenStatus() {
    if [ $1 != "0" ]; then
        tcli_linux_logger_infoscreenFailed
    else
        tcli_linux_logger_infoscreenDone
    fi
}

## @fn tcli_linux_logger_errorCheck()
## @details
## **TODO**
tcli_linux_logger_errorCheck() {
	if [ $? -eq 0 ]; then
		printf "${TCLI_LINUX_LOGGER_RED}An error has occured.${TCLI_LINUX_LOGGER_NC}"
		# read -p "Press enter or space to ignore it. Press any other key to abort." -n 1 key
		# if [[ $key != "" ]]; then
		# 	exit
		# fi
	fi
}

## @fn tcli_linux_logger_title()
## @details
## **Title**
## Creating a box around title
## Fillerlength is numbers of char horizontialt
## @param string title
## @param string fillerlength ( default value 80 )
## @param char filler char ( default value +)
tcli_linux_logger_title() {
  local _title=${1:-}
  local -i _fillerlength=${2:-80}
  (( _fillerlength-- ))
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

## @fn tcli_linux_logger_file_info()
## @details
## **Info to log file**
## @param string message
## @param string function or other notice in front of message
tcli_linux_logger_file_info() {
  tcli_linux_logger_file "Info" ${1:-} ${2:-}
}

## @fn tcli_linux_logger_file_warn()
## @details
## **Warning to log file**
## @param string message
## @param string function or other notice before message
tcli_linux_logger_file_warn() {
  tcli_linux_logger_file "Warn" ${1:-} ${2:-}
}

## @fn tcli_linux_logger_file_error()
## @details
## **Error to log file**
## @param string message
## @param string function or other notice before message
tcli_linux_logger_file_error() {
  tcli_linux_logger_file "Error" ${1:-} ${2:-}
}

## @fn tcli_linux_logger_file()
## @details
## **Error to log file**
## @param string level message
## @param string message
## @param string function or other notice before message
tcli_linux_logger_file() {
  local _msg
  if [[ -n "${2:-}" && -n "${3:-}" ]]; then
    _msg="${3} : ${2}"
  elif [[ -n "${2:-}" ]]; then
    _msg="${2}"
  elif [[ -n "${3:-}" ]]; then
    _msg="${3}"
  else
     tcli_linux_logger_file_warn "tcli_linux_logger_file" "missing message"
     return 1
  fi
  echo "[$(date +%Y-%m-%d\ %T.%6N)] ${1:-} >>> ${_msg}" >&3
}
