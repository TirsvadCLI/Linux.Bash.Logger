[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<br />
<div align="center">
    <a href="https://github.com/TirsvadCLI/Linux.Bash.Logger">
        <img src="images/logo.png" alt="Logo" width="80" height="80">
    </a>
</div>

# Linux Logger
This is a shell script designed to handle logging for various processes. It can log information to the screen and redirect logs to a specified file, allowing for better error tracking and process monitoring.

## Table of Contents
- [Features](#features)
- [Getting Started](#getting-started)
    - [Clone the Repository](#clone-the-repository)
- [Functions](#functions)
- [Usage](#usage)
- [Testing](#testing)
    - [Docker issues](#docker-issue)
- [Contribution](#contribution)
- [Code of conduct](#code-of-conduct)

## Features
- Outputs logging information to the console
- Logs both information and errors to a specified log file
- Supports different log levels (Info, Warn, Error)
- Color-coded terminal output for better readability

## Getting Started
To use this logger script:

### Clone the Repository
```bash
git clone git@github.com:TirsvadCLI/Linux.Bash.Logger.git
```

## Functions
### Initialization
- ` tcli_linux_bash_logger_init()`: Initializes the logger, setting up output redirection and logging the start of the logger.

### Logging Messages
- ` tcli_linux_bash_logger_infoscreen()`: Displays an info message during processing.
- ` tcli_linux_bash_logger_infoscreenDone()`: Shows a "DONE" message when a process is completed successfully.
- ` tcli_linux_bash_logger_infoscreenFailed()`: Displays a "FAILED" message, including an error message.
- ` tcli_linux_bash_logger_infoscreenFailedExit()`: Displays failure messages and exits the script with a specified error code.
- ` tcli_linux_bash_logger_infoscreenWarn()`: Displays a warning message.

### Status Checking
- ` tcli_linux_bash_logger_infoscreenStatus()`: Checks the status of a command and logs either a failure or success message.

### Title Logging
- ` tcli_linux_bash_logger_title()`: Creates a formatted title box for better organization in the logs.

### File Logging
- ` tcli_linux_bash_logger_file_info()`: Logs informational messages to the log file.
- ` tcli_linux_bash_logger_file_warn()`: Logs warning messages.
- ` tcli_linux_bash_logger_file_error()`: Logs error messages.
- ` tcli_linux_bash_logger_file()`: Generic function to handle the actual file logging for various levels.

## Usage
1. `Source Run.sh` in the start of your script.
2. To use the logger, initialize it by calling `tcli_linux_bash_logger_init("path/to/logfile.log")` with the desired log file path.
3. Use the functions provided to log messages at different stages of your process.
4. Check the log file for detailed information about process execution.

## Testing
To create a Docker image for testing, use the following command:
```bash
docker-compose build
```

To run the test in the Docker container, execute:
```bash
docker run --rm -it tirsvadclilinuxbashlogger_debian_service:latest
```

In the docker console
```bash
bash test_Run.sh 
```

### Docker issue

Follow this guide

[Step 1](https://docs.docker.com/engine/install/linux-postinstall/)

[Step 2](https://docs.docker.com/engine/security/rootless/)

## Contribution
See more [here](CONTRIBUTING.md)

## Code of conduct
See more [here](CODE_OF_CONDUCT.md)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/TirsvadCLI/Linux.Bash.Logger?style=for-the-badge
[contributors-url]: https://github.com/TirsvadCLI/Linux.Bash.Logger/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/TirsvadCLI/Linux.Bash.Logger?style=for-the-badge
[forks-url]: https://github.com/TirsvadCLI/Linux.Bash.Logger/network/members
[stars-shield]: https://img.shields.io/github/stars/TirsvadCLI/Linux.Bash.Logger?style=for-the-badge
[stars-url]: https://github.com/TirsvadCLI/Linux.Bash.Logger/stargazers
[issues-shield]: https://img.shields.io/github/issues/TirsvadCLI/Linux.Bash.Logger?style=for-the-badge
[issues-url]: https://github.com/TirsvadCLI/Linux.Bash.Logger/issues
[license-shield]: https://img.shields.io/github/license/TirsvadCLI/Linux.Bash.Logger?style=for-the-badge
[license-url]: https://github.com/TirsvadCLI/Linux.Bash.Logger/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/jens-tirsvad-nielsen-13b795b9/
