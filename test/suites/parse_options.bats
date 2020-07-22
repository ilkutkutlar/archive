#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/archive/parse_options.sh"
  source "${PROJECT_ROOT}/lib/archive/help.sh"
  source "${PROJECT_ROOT}/lib/archive/constants.sh"
}


# ============
#  Add option
# ============


@test "parsing options: add option without delete flag" {
  parse_options -a file_name.txt
  [ "${action}" = "${ACTION_ADD}" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 0 ]

  parse_options --add file_name.txt
  [ "${action}" = "${ACTION_ADD}" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 0 ]
}

@test "parsing options: add option with delete flag" {
  parse_options -a file_name.txt -d
  [ "${action}" = "${ACTION_ADD}" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 1 ]

  parse_options --add file_name.txt --delete
  [ "${action}" = "${ACTION_ADD}" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 1 ]
  
  parse_options --add file_name.txt -d
  [ "${action}" = "${ACTION_ADD}" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 1 ]
}

@test "parsing options: add option with missing required file argument" {
  # Use run so that test doesn't fail due to
  # parse_options returning 1
  run parse_options -a
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "No file argument given to '-a/--add' option" ]

  run parse_options --add
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "No file argument given to '-a/--add' option" ]
}


# ==================
#  Unarchive option
# ==================


@test "parsing options: unarchive option without delete flag" {
  parse_options -u file_name.txt
  [ "${action}" = "${ACTION_UNARCHIVE}" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 0 ]

  parse_options --unarchive file_name.txt
  [ "${action}" = "${ACTION_UNARCHIVE}" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 0 ]
}

@test "parsing options: unarchive option with delete flag" {
  parse_options -u file_name.txt -d
  [ "${action}" = "${ACTION_UNARCHIVE}" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 1 ]

  parse_options --unarchive file_name.txt --delete
  [ "${action}" = "${ACTION_UNARCHIVE}" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 1 ]
  
  parse_options --unarchive file_name.txt -d
  [ "${action}" = "${ACTION_UNARCHIVE}" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 1 ]
}

@test "parsing options: unarchive option with missing required file argument" {
  # Use run so that test doesn't fail due to
  # parse_options returning 1
  run parse_options -u
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "No file argument given to '-u/--unarchive' option" ]

  run parse_options --unarchive
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "No file argument given to '-u/--unarchive' option" ]
}


# =============
#  List option
# =============


@test "parsing options: list option" {
  parse_options -l
  [ "${action}" = "${ACTION_LIST}" ]
  [ -z "${file}" ]
  [ "${remove_files}" -eq 0 ]

  parse_options --list
  [ "${action}" = "${ACTION_LIST}" ]
  [ -z "${file}" ]
  [ "${remove_files}" -eq 0 ]
}

@test "parsing options: top-level list option" {
  parse_options -t
  [ "${action}" = "${ACTION_TOP_LEVEL_LIST}" ]
  [ -z "${file}" ]
  [ "${remove_files}" -eq 0 ]

  parse_options --top-level
  [ "${action}" = "${ACTION_TOP_LEVEL_LIST}" ]
  [ -z "${file}" ]
  [ "${remove_files}" -eq 0 ]
}

# =============
#  Help option
# =============


@test "parsing options: help option" {
  parse_options -h
  [ "${action}" = "${ACTION_HELP}" ]
  [ -z "${file}" ]
  [ "${remove_files}" -eq 0 ]

  parse_options --help
  [ "${action}" = "${ACTION_HELP}" ]
  [ -z "${file}" ]
  [ "${remove_files}" -eq 0 ]
}


# ================
#  Version option
# ================


@test "parsing options: version option" {
  parse_options -v
  [ "${action}" = "${ACTION_VERSION}" ]
  [ -z "${file}" ]
  [ "${remove_files}" -eq 0 ]

  parse_options --version
  [ "${action}" = "${ACTION_VERSION}" ]
  [ -z "${file}" ]
  [ "${remove_files}" -eq 0 ]
}


# =================
#  Invalid options
# =================


@test "parsing options: invalid options" {
  # Use run so that test doesn't fail due to
  # parse_options returning 1
  run parse_options -l -v
  [ "${lines[0]}" = "Incorrect set of options given" ]
  [ "${status}" -eq 1 ]

  run parse_options --list --version
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Incorrect set of options given" ]

  run parse_options -q
  [ "${status}" -eq 1 ]
  [ -z "${output}" ]

  run parse_options --quiet
  [ "${status}" -eq 1 ]
  [ -z "${output}" ]
}
