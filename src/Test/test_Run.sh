#!/bin/bash

## @file test_Run.sh
## @author Jens Tirsvad Nielsen
## @brief Test Logger
## @details
## **Test Logger**

declare -g TEST_PATH_SCRIPTDIR="$(dirname "$(realpath "${BASH_SOURCE}")")"
declare -g TEST_PATH_APP=$(realpath "${TEST_PATH_SCRIPTDIR}/../Logger")
declare -i -g TEST_PASSED=0
declare -i -g TEST_FAILED=0
declare -g TEST_LOG_FILE="${TEST_PATH_SCRIPTDIR}/test.log"

. ${TEST_PATH_APP}/Run.sh

## @fn test_tcli_linux_bash_logger_init
## @brief Test for tcli_linux_bash_logger_init
## @details
## **Test for tcli_linux_bash_logger_init**
## - If log file exists, remove it
## - Call tcli_linux_bash_logger_init
## - If log file exists, print PASSED
## - Else print FAILED
test_tcli_linux_bash_logger_init() {
	if [ -f "${TEST_LOG_FILE}" ]; then
		rm $TEST_LOG_FILE
	fi
	tcli_linux_bash_logger_init "${TEST_LOG_FILE}"
	if [ -f "${TEST_LOG_FILE}" ]; then
		echo "PASSED tcli_linux_bash_logger_init"
		TEST_PASSED+=1
	else
		echo "FAILED tcli_linux_bash_logger_init"
		TEST_FAILED+=1
	fi
}

## @fn test_tcli_linux_bash_logger_infoscreen
## @brief Test for tcli_linux_bash_logger_infoscreen
## @details
## **Test for tcli_linux_bash_logger_infoscreen**
## - Redirect stdout to test.log
## - Clear file test.log
## - Call tcli_linux_bash_logger_infoscreen with test_message
## - Redirect stdout back to terminal
## - Read test.log to actual_output
## - Compare expected_output with actual_output
## - If equal, print PASSED
## - Else print FAILED
test_tcli_linux_bash_logger_infoscreen() {

	local test_message="Test Info Screen"
	local expected_output="[......] \033[0;33m${test_message}\033[0m"
	
	# Redirect stdout to test.log
	exec 3>&1 1>test.log

	# Clear file test.log
	echo "" > test.log

	tcli_linux_bash_logger_infoscreen "${test_message}"

	# Redirect stdout back to terminal
	exec 1>&3 3>&-

	local actual_output=$(cat test.log)

	if diff <(printf "${expected_output}") <(printf "${actual_output}"); then
		echo "PASSED tcli_linux_bash_logger_infoscreen"
		TEST_PASSED+=1
	else
        echo "Differences:"
        diff -n --ignore-space-change <(printf "${expected_output}") <(printf "${actual_output}")
        printf "\nExpected Output (with non-printing characters):\n"
        printf "${expected_output}" | cat -A
        printf "\nActual Output (with non-printing characters):\n"
        printf "${actual_output}" | cat -A
		echo ""
		exit 0
		echo "FAILED tcli_linux_bash_logger_infoscreen"
		TEST_FAILED+=1
	fi
}

## @fn test_tcli_linux_bash_logger_infoscreenDone
## @brief Test for tcli_linux_bash_logger_infoscreenDone
## @details
## **Test for tcli_linux_bash_logger_infoscreenDone**
## - Redirect stdout to test.log
## - Clear file test.log
## - Call tcli_linux_bash_logger_infoscreen with test_message
## - Call tcli_linux_bash_logger_infoscreenDone
## - Redirect stdout back to terminal
## - Read test.log to actual_output
## - Compare expected_output with actual_output
## - If equal, print PASSED
## - Else print FAILED
test_tcli_linux_bash_logger_infoscreenDone() {

	local test_message="Test Info Screen"
	local expected_output="[......] \033[0;33mTest Info Screen\033[0m\r\033[1C\033[0;32m DONE \033[0m"
	#local expected_output="[......] ${TCLI_LINUX_BASH_LOGGER_BROWN}Test Info Screen${TCLI_LINUX_BASH_LOGGER_NC}${TCLI_LINUX_BASH_BACK_TO_LINE}${TCLI_LINUX_BASH_LOGGER_GREEN} DONE ${TCLI_LINUX_BASH_LOGGER_NC}"

	# Redirect stdout to test.log
	exec 3>&1 1>test.log

	# Clear file test.log
	echo "" > test.log

	tcli_linux_bash_logger_infoscreen "${test_message}"
	tcli_linux_bash_logger_infoscreenDone

	# Redirect stdout back to terminal
	exec 1>&3 3>&-

	local actual_output=$(cat test.log)

	if diff <(printf "${expected_output}") <(printf "${actual_output}"); then
		echo "PASSED tcli_linux_bash_logger_infoscreenDone"
		TEST_PASSED+=1
	else
        echo "Differences:"
        diff -n --ignore-space-change <(printf "${expected_output}") <(printf "${actual_output}")
        #printf "\nExpected Output (with non-printing characters):\n"
        #printf "${expected_output}" | cat -A
        #printf "\nActual Output (with non-printing characters):\n"
        #printf "${actual_output}" | cat -A
		#echo ""
		echo "FAILED tcli_linux_bash_logger_infoscreen"
		TEST_FAILED+=1
	fi
}

## @fn test_tcli_linux_bash_logger_infoscreenFailed
## @brief Test for tcli_linux_bash_logger_infoscreenFailed
## @details
## **Test for tcli_linux_bash_logger_infoscreenFailed**
## - Redirect stdout to test.log
## - Clear file test.log
## - Call tcli_linux_bash_logger_infoscreen with test_message
## - Call tcli_linux_bash_logger_infoscreenFailed
## - Redirect stdout back to terminal
## - Read test.log to actual_output
## - Compare expected_output with actual_output
## - If equal, print PASSED
## - Else print FAILED
test_tcli_linux_bash_logger_infoscreenFailed() {
	local test_message="Test Info Screen"
	local expected_output="[......] \033[0;33mTest Info Screen\033[0m\r\033[1C\033[0;31mFAILED\033[0m"
	#local expected_output="[......] ${TCLI_LINUX_BASH_LOGGER_BROWN}Test Info Screen${TCLI_LINUX_BASH_LOGGER_NC}${TCLI_LINUX_BASH_BACK_TO_LINE}${TCLI_LINUX_BASH_LOGGER_RED}FAILED${TCLI_LINUX_BASH_LOGGER_NC}"

	# Redirect stdout to test.log
	exec 3>&1 1>test.log

	# Clear file test.log
	echo "" > test.log

	TCLI_LINUX_BASH_LOGGER_LOT_TO_FILE=0

	tcli_linux_bash_logger_infoscreen "${test_message}"
	tcli_linux_bash_logger_infoscreenFailed

	TCLI_LINUX_BASH_LOGGER_LOT_TO_FILE=1

	# Redirect stdout back to terminal
	exec 1>&3 3>&-

	local actual_output=$(cat test.log)

	if diff <(printf "${expected_output}") <(printf "${actual_output}"); then
		echo "PASSED tcli_linux_bash_logger_infoscreenFailed"
		TEST_PASSED+=1
	else
        echo "Differences:"
        diff -n --ignore-space-change <(printf "${expected_output}") <(printf "${actual_output}")
        printf "\nExpected Output (with non-printing characters):\n"
        printf "${expected_output}" | cat -A
        printf "\nActual Output (with non-printing characters):\n"
        printf "${actual_output}" | cat -A
		echo ""
		echo "FAILED tcli_linux_bash_logger_infoscreen"
		TEST_FAILED+=1
	fi
}

## @fn test_tcli_linux_bash_logger_infoscreenFailedExit
## @brief Test for tcli_linux_bash_logger_infoscreenFailedExit
## @details
## **Test for tcli_linux_bash_logger_infoscreenFailedExit**
## - Redirect stdout to test.log
## - Clear file test.log
## - Call tcli_linux_bash_logger_infoscreen with test_message
## - Call tcli_linux_bash_logger_infoscreenFailedExit
## - Redirect stdout back to terminal
## - Read test.log to actual_output
## - Compare expected_output with actual_output
## - If equal, print PASSED
## - Else print FAILED
test_tcli_linux_bash_logger_title() {
	local test_message="Test Info Screen"
	local expected_output="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n++++++++++++++++++++++++++++++ Test Info Screen +++++++++++++++++++++++++++++++\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

	# Redirect stdout to test.log
	exec 3>&1 1>test.log

	# Clear file test.log
	echo "" > test.log

	tcli_linux_bash_logger_title "${test_message}"

	# Redirect stdout back to terminal
	exec 1>&3 3>&-

	local actual_output=$(cat test.log)

	if diff <(printf "${expected_output}") <(printf "${actual_output}"); then
		echo "PASSED tcli_linux_bash_logger_title"
		TEST_PASSED+=1
	else
		echo "Differences:"
		diff -n --ignore-space-change <(printf "${expected_output}") <(printf "${actual_output}")
		printf "\nExpected Output (with non-printing characters):\n"
		printf "${expected_output}" | cat -A
		printf "\nActual Output (with non-printing characters):\n"
		printf "${actual_output}" | cat -A
		echo ""
		echo "FAILED tcli_linux_bash_logger_title"
		TEST_FAILED+=1
	fi
}

# Run all tests
test_tcli_linux_bash_logger_init
test_tcli_linux_bash_logger_infoscreen
test_tcli_linux_bash_logger_infoscreenDone
test_tcli_linux_bash_logger_infoscreenFailed
#test_tcli_linux_bash_logger_infoscreenFailedExit
#test_tcli_linux_bash_logger_infoscreenWarn
test_tcli_linux_bash_logger_title
echo ""
echo "Tests Passed: ${TEST_PASSED}"
echo "Tests Failed: ${TEST_FAILED}"
