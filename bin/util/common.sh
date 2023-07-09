#!/bin/bash

# Switch title ID for KotOR II
title_id="0100B2C016252000"
# root romfs folder
game_root_base_name="romfs"
game_dir="./${title_id}/${game_root_base_name}"
finalized_canary="${game_dir}/.finalized"
assets_dir="./supporting-assets" 
# where to store backups of the romfs folder
backup_dir="./${game_root_base_name}.backup"
# directory for the collection of file lists
file_list_dir="./file-lists"

# game override directory
override_prefix="override"
override_dir="${game_dir}/${override_prefix}"

# the Localized English folder as it appears in the Switch-only game folder
localized_prefix="Localized/English"
localized_dir="${game_dir}/${localized_prefix}"

# text color utilities
SUCCESS_TEXT="\033[00;32m"
WARNING_TEXT="\033[33m"
ERROR_TEXT="\033[31m"
RESTORE_TEXT="\033[0m"

# helper text color functions
function success {
  echo -e "${SUCCESS_TEXT}$1${RESTORE_TEXT}"
}
function warning {
  echo -e "${WARNING_TEXT}$1${RESTORE_TEXT}"
}
function error {
  echo -e "${ERROR_TEXT}$1${RESTORE_TEXT}"
}

# pre-flight checks
function common_preflight {
  # ensure requisite folders are present
  if [ ! -d "${game_dir}" ]; then
    echo ""
    error "${game_dir} cannot be found. Exiting."
    exit 10
  fi
  if [ ! -d "${file_list_dir}" ]; then
    echo ""
    error "${file_list_dir} cannot be found. Exiting."
    exit 11
  fi
}

# game folder status functions
function is_initialized {
  [ -d "${override_dir}" ] && return 0 || return 1
}
function is_finalized {
  [ -f "${finalized_canary}" ] && return 0 || return 1
}
