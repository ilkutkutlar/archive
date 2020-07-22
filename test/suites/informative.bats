#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/archive/constants.sh"
  source "${PROJECT_ROOT}/lib/archive/informative.sh"
}

@test "listing files in archive" {
  run list "${FIXTURES_DIR}/dummy_archive.tar"
  local expected="Files in archive:
test.txt
test_dir/
test_dir/test1.txt"

  [ "${output}" = "${expected}" ]
}

@test "list top-level files in archive" {
  run list_top_level "${FIXTURES_DIR}/dummy_archive.tar"
  local expected="Top-level files in archive:
test.txt
test_dir/"

  [ "${output}" = "${expected}" ]
}
