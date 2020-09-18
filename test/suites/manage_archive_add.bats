#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/archive/manage_archive.sh"
  
  remove_old_test_archive
  remove_old_test_files
  create_test_files
}

@test "archiving files" {
  run add_to_archive "${TEST_FILE}" 0 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${TEST_FILE} added to archive" ]

  run add_to_archive "${TEST_DIR}" 0 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${TEST_DIR} added to archive" ]

  [ -f "${TEST_FILE}" ]
  [ -d "${TEST_DIR}" ]

  local expected_contents="test.txt
test_dir/
test_dir/test1.txt"
  assert_test_archive_contents "${expected_contents}"
}

@test "archiving files in a different directory to archive" {
  different_test_file="${BATS_TMPDIR}/different_dir/test_file.txt"

  rm -rf "${BATS_TMPDIR}/different_dir"
  mkdir "${BATS_TMPDIR}/different_dir"
  touch "${different_test_file}"

  run add_to_archive "${different_test_file}" 0 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${different_test_file} added to archive" ]

  [ -f "${different_test_file}" ]

  local expected_contents="test_file.txt"
  assert_test_archive_contents "${expected_contents}"
}

@test "archiving files with spaces in name" {
  run add_to_archive "${TEST_FILE_SPACES}" 0 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${TEST_FILE_SPACES} added to archive" ]

  [ -f "${TEST_FILE_SPACES}" ]

  local expected_contents="test file with spaces.txt"
  assert_test_archive_contents "${expected_contents}"
}

@test "archiving files followed by removing" {
  run add_to_archive "${TEST_FILE}" 1 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${TEST_FILE} added to archive" ]

  run add_to_archive "${TEST_DIR}" 1 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${TEST_DIR} added to archive" ]
  
  [ ! -f "${TEST_FILE}" ]
  [ ! -d "${TEST_DIR}" ]

  local expected_contents="test.txt
test_dir/
test_dir/test1.txt"
  assert_test_archive_contents "${expected_contents}"
}

@test "archiving files with spaces in name followed by removing" {
  run add_to_archive "${TEST_FILE_SPACES}" 1 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${TEST_FILE_SPACES} added to archive" ]
  
  [ ! -f "${TEST_FILE_SPACES}" ]

  local expected_contents="test file with spaces.txt"
  assert_test_archive_contents "${expected_contents}"
}

@test "error during archiving files" {
  # Remove read permission to create error
  chmod a-r "${TEST_FILE}"

  run add_to_archive "${TEST_FILE}" 0 "${TEST_ARCHIVE_TAR}"
  [ "${lines[0]}" = "tar: test.txt: Cannot open: Permission denied" ]

  [ -f "${TEST_FILE}" ]
  [ -d "${TEST_DIR}" ]

  # Error, so archive should be empty
  [ -z "$( test_archive_contents )" ] 
}
