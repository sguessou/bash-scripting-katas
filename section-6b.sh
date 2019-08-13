#!/bin/bash

log() {
  # This function sends a message to syslog and to standard output if VERBOSE is true.
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
  logger -t section-6a.sh "${MESSAGE}"
}

perform_backup() {
  # This function creates a backup of a file. Returns non-zero status on error.

  local FILE="${1}"
  echo "${FILE}" 
  # Make sure the file exists.
  if [[ -f "${FILE}" ]]
  then
    local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
    log "Backing up ${FILE} to ${BACKUP_FILE}"

    # The exit status of the function will be the exit status of the cp command.
    cp -p ${FILE} ${BACKUP_FILE}
  else
    # The file does not exist, so returns a non-zero exit status.
    return 1
  fi
}

check_backup() {
  # Make a decision based on the exit status of the function
  if [[ "${?}" -eq '0' ]]
  then
    log 'File backup succeeded!'
  else
    log 'File backup failed!'
    exit 1
  fi
}

backup_file() {
  # 
  perform_backup "${1}"
  check_backup
}

readonly VERBOSE=true

backup_file "${1}"
