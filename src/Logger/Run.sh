#!/bin/bash

## @file logger.sh
## @brief Logger for screen and file
## @details
## This is a shell script designed to handle logging for various processes. It can log information to the screen and redirect logs to a specified file, allowing for better error tracking and process monitoring.
##
## @author Jens Tirsvad Nielsen
## @date May 2023

## @brief string internal field separator
IFS=$'\n\t'

## @brief string script directory
declare -g TCLI_LINUX_BASH_LOGGER_SCRIPTDIR="$(dirname "$(realpath "${BASH_SOURCE}")")"

. $TCLI_LINUX_BASH_LOGGER_SCRIPTDIR/inc/constants.sh

## @fn tcli_linux_bash_logger_init()
## @details
## **Initial logger**
## All error go to log file
## Output to file example
## printf "this output is visible" 
## @param string full path of the log file
tcli_linux_bash_logger_init() {
	local _file=${1}
	local _dir
	_dir=$(dirname "${1}")
	[ ! -d ${_dir} ] && mkdir $_dir || rm -f ${1}
    exec 2>$_file
	tcli_linux_bash_logger_file_info "Loaded" "Logger $TCLI_LINUX_BASH_LOGGER_VERSION"
}

## @fn tcli_linux_bash_logger_infoscreen()
## @details
## **Info of the process step [ ... ]**
## @param string message
## @param string message part 2 (optional)
tcli_linux_bash_logger_infoscreen() {
    if [ $2 ]; then
        local n=" "
    else
        local n=""
    fi
	printf $(printf "[......] ${TCLI_LINUX_BASH_LOGGER_BROWN}$1${n}${TCLI_LINUX_BASH_LOGGER_NC}$2$n")
}

## @fn tcli_linux_bash_logger_infoscreenDone()
## @details
## **Info of the process step [ DONE ]**
tcli_linux_bash_logger_infoscreenDone() {
	printf "\r\033[1C${TCLI_LINUX_BASH_LOGGER_GREEN} DONE ${TCLI_LINUX_BASH_LOGGER_NC}\n"
	#printf "\r\033[80C\n" 
}

## @fn tcli_linux_bash_logger_infoscreenFailed()
## @details
## **Info of the process step [ FAILED ]**
## @param string error message part 1 red color
## @param string error message part 2 blue color
## @param string error message part 3 red color
## @param string function or other notice in front of message
tcli_linux_bash_logger_infoscreenFailed() {
	local -a _errormsg
	[ ${1:-} ] && _errormsg=($1)
	[ ${2:-} ] && _errormsg+=($2)
	[ ${3:-} ] && _errormsg+=($3)
	[ ${TCLI_LINUX_BASH_LOGGER_INFOSCREEN_WARN} == 1 ] && TCLI_LINUX_BASH_LOGGER_INFOSCREEN_WARN=0
	printf "${TCLI_LINUX_BASH_BACK_TO_LINE}${TCLI_LINUX_BASH_LOGGER_RED}FAILED${TCLI_LINUX_BASH_LOGGER_NC}\n"
	[ ${TCLI_LINUX_BASH_LOGGER_TO_FILE} == 1 ] && tcli_linux_bash_logger_file_error $(echo ${_errormsg[@]}) ${4:-}
}

## @fn tcli_linux_bash_logger_infoscreenFailedExit()
## @details
## **Info of the process step [ FAILED ]**
## Then it will exit with a error code
## @param string error message part 1 red color
## @param string error message part 2 blue color
## @param string error message part 3 red color
## @param interger exit code (default is 1)
## @param string error cause
tcli_linux_bash_logger_infoscreenFailedExit() {
	tcli_linux_bash_logger_infoscreenFailed "${1:-}" "${2:-}" "${3:-}" "${5:-}"
	[ ${4:-} ] && printf "${TCLI_LINUX_BASH_LOGGER_RED}${1} : "
	[ ${1:-} ] && printf "${TCLI_LINUX_BASH_LOGGER_RED}${1}"
	[ ${2:-} ] && printf " ${TCLI_LINUX_BASH_LOGGER_BLUE}${2}"
	[ ${3:-} ] && printf " ${TCLI_LINUX_BASH_LOGGER_RED}${3}"
	printf "${TCLI_LINUX_BASH_LOGGER_NC}\n" 
	exit ${4:-1}
}

## @fn tcli_linux_bash_logger_infoscreenWarn()
## @details
## **Info of the process step [ FAILED ]**
## Then exit with a error code
tcli_linux_bash_logger_infoscreenWarn() {
	printf "\r\033[1C${TCLI_LINUX_BASH_LOGGER_YELLOW} WARN ${TCLI_LINUX_BASH_LOGGER_NC}\n" 
	TCLI_LINUX_BASH_LOGGER_INFOSCREEN_WARN=1
}

## @fn tcli_linux_bash_logger_infoscreenStatus()
tcli_linux_bash_logger_infoscreenStatus() {
	if [ $1 != "0" ]; then
		tcli_linux_bash_logger_infoscreenFailed
	else
		tcli_linux_bash_logger_infoscreenDone
	fi
}

## @fn tcli_linux_bash_logger_errorCheck()
## @details
## **TODO**
tcli_linux_bash_logger_errorCheck() {
	if [ $? -eq 0 ]; then
		printf "${TCLI_LINUX_BASH_LOGGER_RED}An error has occured.${TCLI_LINUX_BASH_LOGGER_NC}" 
		# read -p "Press enter or space to ignore it. Press any other key to abort." -n 1 key
		# if [[ $key != "" ]]; then
		# 	exit
		# fi
	fi
}

## @fn tcli_linux_bash_logger_title()
## @details
## **Title**
## Creating a box around title
## Fillerlength is numbers of char horizontialt
## @param string title
## @param string fillerlength ( default value 80 )
## @param char filler char ( default value +)
tcli_linux_bash_logger_title() {
	local _title=${1:-}
	local -i _fillerlength=${2:-80}
	((_fillerlength--))
	local _fillerchar=${3:-"+"}
	local -i _n_pad=$(((${_fillerlength} - ${#_title} - 2) / 2))
	local -i _i=$(($_n_pad * 2 + 2 + ${#_title}))
	printf -- "${_fillerchar}%.0s" $(seq ${_fillerlength}) 
	printf "\n" 
	printf -- "${_fillerchar}%.0s" $(seq ${_n_pad}) 
	printf $(printf ' %s ' "$_title") 
	if [ $(($_n_pad * 2 + ${#_title} + 2)) -lt ${_fillerlength} ]; then
		((_n_pad++))
	fi
	printf -- "${_fillerchar}%.0s" $(seq ${_n_pad}) 
	printf "\n" 
	printf -- "${_fillerchar}%.0s" $(seq ${_fillerlength}) 
	printf "\n" 
}

## @fn tcli_linux_bash_logger_screen_info()
## @details
## **Info to screen**
## @param string message
tcli_linux_bash_logger_screen_error() {
	local err=$1
	printf "${TCLI_LINUX_BASH_LOGGER_RED}Error: ${err}${TCLI_LINUX_BASH_LOGGER_NC}\n"
}

## @fn tcli_linux_bash_logger_file_info()
## @details
## **Info to log file**
## @param string message
## @param string function or other notice in front of message
tcli_linux_bash_logger_file_info() {
	tcli_linux_bash_logger_file "Info" ${1:-} ${2:-}
}

## @fn tcli_linux_bash_logger_file_warn()
## @details
## **Warning to log file**
## @param string message
## @param string function or other notice before message
tcli_linux_bash_logger_file_warn() {
	tcli_linux_bash_logger_file "Warn" ${1:-} ${2:-}
}

## @fn tcli_linux_bash_logger_file_error()
## @details
## **Error to log file**
## @param string message
## @param string function or other notice before message
tcli_linux_bash_logger_file_error() {
	tcli_linux_bash_logger_file "Error" ${1:-} ${2:-}
}

## @fn tcli_linux_bash_logger_file()
## @details
## **Error to log file**
## @param string level message
## @param string message
## @param string function or other notice before message
tcli_linux_bash_logger_file() {
	local _msg
	if [[ -n "${2:-}" && -n "${3:-}" ]]; then
		_msg="${3} : ${2}"
	elif [[ -n "${2:-}" ]]; then
		_msg="${2}"
	elif [[ -n "${3:-}" ]]; then
		_msg="${3}"
	else
		tcli_linux_bash_logger_file_warn "tcli_linux_bash_logger_file" "missing message"
		return 1
	fi
	echo "[$(date +%Y-%m-%d\ %T.%6N)] ${1:-} >>> ${_msg}" >&2
}
