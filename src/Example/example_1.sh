#!/bin/bash

. ../Logger/Run.sh

tcli_linux_bash_logger_init "/tmp/example_1.log"

tcli_linux_bash_logger_title "Example 1: Logger to screen"

tcli_linux_bash_logger_infoscreen "This is an info message"
tcli_linux_bash_logger_infoscreenDone

tcli_linux_bash_logger_infoscreen "Example of a warning"
tcli_linux_bash_logger_infoscreenWarn

tcli_linux_bash_logger_infoscreen "Example of some code failing"
tcli_linux_bash_logger_infoscreenFailed "Some error message" "from codesnippet" # this will be written to the log file