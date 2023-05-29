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

test_fildiscripter_3_false () {
  info "fildiscripter 3 should not be avaible"
  if { >&3; } 2> /dev/null; then
    info_failed
  else
    info_passed
  fi
}

test_tcli_logger_init() {
  info "tcli_logger_init create directory and file"
  if tcli_logger_init "${TEST_PATH_SCRIPTDIR}/log/mytest.log"; then
    info_passed
  else
    info_failed
  fi
}

test_fildiscripter_3_true () {
  info "fildiscripter 3 is avaible"
  if { >&3; } 2> /dev/null; then
    info_passed
  else
    info_failed
  fi
}

test_tcli_logger_title() {
  local valid
  local result
  result=$(tcli_logger_title "The title" 80)
  valid="++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++ The title +++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  info "tcli_logger_title set 1"
  [ "$result" = "$valid" ] && info_passed || info_failed

  valid="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++ The title number two meget langt +++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  result=$(tcli_logger_title "The title number two meget langt" 63)
  info "tcli_logger_title set 2"
  [ "$result" = "$valid" ] || info_failed && info_passed
}

info_repport() {
  printf "\nTest result\n"
  printf "Passed ${TEST_PASSED}\n"
  printf "Failed ${TEST_FAILED}\n"
}

# tests
test_fildiscripter_3_false
test_tcli_logger_init
test_fildiscripter_3_true
test_tcli_logger_title

info_repport

rm -rf ${TEST_PATH_SCRIPTDIR}/log