#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/defaults.sh"
  source "${PROJECT_ROOT}/lib/informative.sh"
}

@test "listing files in archive" {
  local actual="$( list "${FIXTURES_DIR}/dummy_archive.tar" )"
  local expected="Files in archive:
test.txt
test_dir/
test_dir/test1.txt"

  [ "${actual}" = "${expected}" ]
}

@test "list top-level files in archive" {
  local actual="$( list_top_level "${FIXTURES_DIR}/dummy_archive.tar" )"
  local expected="Top-level files in archive:
test.txt
test_dir/"

  echo "${actual}"
  echo "${expected}"
  [ "${actual}" = "${expected}" ]
}
