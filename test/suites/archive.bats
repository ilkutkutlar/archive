#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/archive.sh"
  source "${PROJECT_ROOT}/lib/help.sh"
}

@test "parsing options: single option with no argument" {
  parse_options -l
  [ "${action}" = "list" ]
  [ -z "${file}" ]
  [ "${remove_files}" -eq 0 ]

  parse_options --list
  [ "${action}" = "list" ]
  [ -z "${file}" ]
  [ "${remove_files}" -eq 0 ]
}

@test "parsing options: single option with argument" {
  parse_options -a file_name.txt
  [ "${action}" = "add" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 0 ]

  parse_options --add file_name.txt
  [ "${action}" = "add" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 0 ]
}

@test "parsing options: remove_files flag" {
  parse_options -a file_name.txt -d

  [ "${action}" = "add" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 1 ]

  parse_options --add file_name.txt --delete

  [ "${action}" = "add" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 1 ]
  
  parse_options --add file_name.txt -d

  [ "${action}" = "add" ]
  [ "${file}" = "file_name.txt" ]
  [ "${remove_files}" -eq 1 ]
}

@test "parsing options: invalid options" {
  # Use run so that test doesn't fail due to
  # parse_options returning 1
  run parse_options -l -v

  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Incorrect set of options given" ]

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

@test "parsing options: missing required argument" {
  # Use run so that test doesn't fail due to
  # parse_options returning 1
  run parse_options -a

  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "No file argument given to '-a/--add' option" ]

  run parse_options --add

  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "No file argument given to '-a/--add' option" ]
}
