#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/defaults.sh"
  source "${PROJECT_ROOT}/lib/info.sh"
}

@test "listing files in archive" {
  local actual="$( list "${FIXTURES_DIR}/list_test_archive.tar" )"
  local expected="Files in archive:
test.txt
test_dir/
test_dir/test1.txt"
  print_test_debug_info

  [ "${actual}" = "${expected}" ]
}

@test "list top-level files in archive" {
  local actual="$( list_top_level "${FIXTURES_DIR}/list_test_archive.tar" )"
  local expected="Top-level files in archive:
test.txt
test_dir/"
  print_test_debug_info

  [ "${actual}" = "${expected}" ]
}
