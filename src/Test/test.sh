#!/bin/bash

## @file
## @author Jens Tirsvad Nielsen
## @brief Test Logger
## @details
## **Test Logger**

declare -g TEST_PATH_SCRIPTDIR="$(dirname "$(realpath "${BASH_SOURCE}")")"
declare -g TEST_PATH_APP=$(realpath "${TEST_PATH_SCRIPTDIR}/../Logger")
declare -i -g TEST_PASSED=0
declare -i -g TEST_FAILED=0

. ${TEST_PATH_APP}/run.sh

## @fn info()
## @details
## **Info to screen**
## @param test message
info() {
  printf "          Test $1\r"
}

## @fn info_passed()
## @details
## **Info to screen**
## send "passed" in front of info message
## counting for later repport
info_passed() {
  printf " PASSED\n"
  TEST_PASSED+=1
}

## @fn info_passed()
## @details
## **Info to screen**
## send "failed" in front of info message
## counting for later repport
info_failed() {
  printf " FAILED\n"
  TEST_FAILED+=1
}

## @fn test_fildiscripter_3_false()
test_fildiscripter_3_false () {
  info "fildiscripter 3 should not be avaible"
  if { >&3; } 2>/dev/null; then
    info_failed
  else
    info_passed
  fi
}

## @fn test_tcli_logger_init()
test_tcli_logger_init() {
  info "tcli_logger_init create directory and file"
  if tcli_logger_init "${TEST_PATH_SCRIPTDIR}/log/mytest.log"; then
    info_passed
  else
    info_failed
  fi
}

## @fn test_fildiscripter_3_true()
test_fildiscripter_3_true () {
  info "fildiscripter 3 is avaible"
  if { >&3; } 2>/dev/null; then
    info_passed
  else
    info_failed
  fi
}

## @fn test_tcli_logger_title()
test_tcli_logger_title() {
  local _valid_test_1="++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n++++++++++++++++++++++++++++++++++ The title +++++++++++++++++++++++++++++++++++\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  local _valid_test_2="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n++++++++++++++ The title number two meget langt +++++++++++++++\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  local _valid_test_3="$(printf -- "-------------------------------------------------------------------------------\n--------------------------------- The title 3 ---------------------------------\n-------------------------------------------------------------------------------")"
  local _result
  
  info "tcli_logger_title set 1"
  _result=$(tcli_logger_title "The title" 81)
  [ "$_result" = "$(printf $_valid_test_1)" ] && info_passed || info_failed

  info "tcli_logger_title set 2"
  _result=$(tcli_logger_title "The title number two meget langt" 64)
  [ "$_result" = "$(printf $_valid_test_2)" ] && info_passed || info_failed


  info "tcli_logger_title set 3"
  _result=$(tcli_logger_title "The title 3" 80 "-")
  [[ "$(printf -- $_result)" == "$(printf -- $_valid_test_3)" ]] && info_passed || info_failed
}

## @fn test_tcli_logger_file_info()
test_tcli_logger_file_info() {
  info "tcli_logger_file_info"
  tcli_logger_file_info "info msg"
  [ $(grep -R "Info >>> info msg" ./log/mytest.log) ] && info_passed || info_failed
}

## @fn test_tcli_logger_file_warn()
test_tcli_logger_file_warn() {
  info "tcli_logger_file_warn"
  tcli_logger_file_warn "warning msg"
  [ $(grep -R "Warn >>> warning msg" ./log/mytest.log) ] && info_passed || info_failed
}

## @fn test_tcli_logger_file_error()
test_tcli_logger_file_error() {
  info "tcli_logger_file_error"
  tcli_logger_file_error "error msg"
  [ $(grep -R "Error >>> error msg" ./log/mytest.log) ] && info_passed || info_failed
}

test_tcli_logger_infoscreenFailed() {
	local _result
  info "tcli_logger_infoscreenFailed"
  _result=$( tcli_logger_infoscreenFailedExit "Must be run as" "root" "" 100 "Unprivileged user")
  [ $(grep -R "Error >>> Unprivileged user : Must be run as root" ./log/mytest.log) ] && info_passed || info_failed
	# TODO test result
}

## @fn info_report()
## @details
## **Generate test repport**
info_report() {
  printf "\n\nTest result\n\n"
  printf "Passed ${TEST_PASSED}\n"
  printf "Failed ${TEST_FAILED}\n"
}

# tests
test_fildiscripter_3_false
test_tcli_logger_init
test_fildiscripter_3_true
test_tcli_logger_title
test_tcli_logger_file_info
test_tcli_logger_file_warn
test_tcli_logger_file_error
test_tcli_logger_infoscreenFailed

info_report

# rm -rf ${TEST_PATH_SCRIPTDIR}/log
