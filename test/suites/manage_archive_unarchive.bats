#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/archive/manage_archive.sh"
  
  remove_old_test_archive
  remove_old_test_files
  create_test_files
}

@test "unarchiving files from archive" {
  # dummy archive contains: 
  # test.txt, test_dir/, test_dir/test1.txt
  cp "${DUMMY_ARCHIVE}" "${TEST_ARCHIVE_TAR}"

  run unarchive "test_dir" 0 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "Retrieved test_dir from archive" ]

  [ -d "$( dirname "${TEST_ARCHIVE_TAR}" )/test_dir" ]
  [ -f "$( dirname "${TEST_ARCHIVE_TAR}" )/test_dir/test1.txt" ]

  local expected_contents="test_dir/
test_dir/test1.txt
test_dir/test_subdir/
test_dir/test_subdir/test2.txt
test.txt"
  assert_test_archive_contents "${expected_contents}"
}

@test "unarchiving files with spaces in name from archive" {
  # dummy archive 2 contains: 
  # test.txt, dir with spaces/, dir with spaces/file with spaces.txt
  cp "${DUMMY_ARCHIVE_2}" "${TEST_ARCHIVE_TAR}"

  run unarchive "dir with spaces" 0 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "Retrieved dir with spaces from archive" ]

  [ -d "$( dirname "${TEST_ARCHIVE_TAR}" )/dir with spaces" ]
  [ -f "$( dirname "${TEST_ARCHIVE_TAR}" )/dir with spaces/file with spaces.txt" ]

  local expected_contents="test.txt
dir with spaces/
dir with spaces/file with spaces.txt"
  assert_test_archive_contents "${expected_contents}"
}

@test "unarchiving files followed by removing from archive" {
  # dummy archive contains: test.txt, test_dir/, test_dir/test1.txt
  cp "${DUMMY_ARCHIVE}" "${TEST_ARCHIVE_TAR}"

  run unarchive "test_dir" 1 "${TEST_ARCHIVE_TAR}"
  local expected_output="Retrieved test_dir from archive
Deleted test_dir from archive permanently"

  [ "${output}" = "${expected_output}" ]
  [ -f "${BATS_TMPDIR}/test_dir/test1.txt" ]
  [ -d "${TEST_DIR}" ]

  local expected_contents="test.txt"
  assert_test_archive_contents "${expected_contents}"
}

@test "unarchiving files with spaces in name followed by removing from archive" {
  # dummy archive 2 contains: 
  # test.txt, dir with spaces/, dir with spaces/file with spaces.txt
  cp "${DUMMY_ARCHIVE_2}" "${TEST_ARCHIVE_TAR}"

  run unarchive "dir with spaces" 1 "${TEST_ARCHIVE_TAR}"
  local expected_output="Retrieved dir with spaces from archive
Deleted dir with spaces from archive permanently"

  [ "${output}" = "${expected_output}" ]
  [ -d "$( dirname "${TEST_ARCHIVE_TAR}" )/dir with spaces" ]
  [ -f "$( dirname "${TEST_ARCHIVE_TAR}" )/dir with spaces/file with spaces.txt" ]

  local expected_contents="test.txt"
  assert_test_archive_contents "${expected_contents}"
}
