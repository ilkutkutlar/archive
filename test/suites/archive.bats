#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/archive.sh"
}

@test "parsing options: single option with no argument" {
  parse_options "-l"
  [ "${action}" = "list" ]
  [ -z "${file}" ]
  [ -z "${remove_files}" ]
}

@test "parsing options: single option with argument" {

}


@test "parsing options: two options with no argument" {

}

@test "parsing options: two options with one argument" {

}

@test "parsing options: invalid options" {

}
