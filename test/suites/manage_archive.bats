#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/constants.sh"
  source "${PROJECT_ROOT}/lib/manage_archive.sh"

  readonly TEST_ARCHIVE_TAR="${BATS_TMPDIR}/${ARCHIVE_TAR}"
  readonly TEST_FILE="${BATS_TMPDIR}/test.txt"
  readonly TEST_DIR="${BATS_TMPDIR}/test_dir"

  remove_old_test_archive
  remove_old_test_files
  create_test_files
}

function remove_old_test_archive() {
  rm -f "${TEST_ARCHIVE_TAR}"
}

function remove_old_test_files() {
  rm -f "${TEST_FILE}"
  rm -rf "${TEST_DIR}"
}

function create_test_files() {
  touch "${TEST_FILE}"
  mkdir -p "${TEST_DIR}"
  touch "${TEST_DIR}/test1.txt"
}

function test_archive_contents() {
  tar -tf "${TEST_ARCHIVE_TAR}"
}

# $1: expected contents
function assert_test_archive_contents() {
  local expected_contents="$1"
  [ "$( test_archive_contents )" = "${expected_contents}" ]
}

@test "archiving files" {
  local output_1="$( add_to_archive "${TEST_FILE}" 0 "${TEST_ARCHIVE_TAR}" )"
  local output_2="$( add_to_archive "${TEST_DIR}" 0 "${TEST_ARCHIVE_TAR}" )"
  
  local expected_contents="test.txt
test_dir/
test_dir/test1.txt"

  [ -f ${TEST_FILE} ]
  [ -d ${TEST_DIR} ]
  [ "${output_1}" = "${TEST_FILE} added to archive" ]
  [ "${output_2}" = "${TEST_DIR} added to archive" ]
  [ "$( test_archive_contents )" = "${expected_contents}" ]
}

@test "archiving files followed by removing" {
  local output_1="$( add_to_archive "${TEST_FILE}" 1 "${TEST_ARCHIVE_TAR}" )"
  local output_2="$( add_to_archive "${TEST_DIR}" 1 "${TEST_ARCHIVE_TAR}" )"
  
  local expected="test.txt
test_dir/
test_dir/test1.txt"

  [ ! -f ${TEST_FILE} ]
  [ ! -d ${TEST_DIR} ]
  [ "${output_1}" = "${TEST_FILE} added to archive" ]
  [ "${output_2}" = "${TEST_DIR} added to archive" ]
  [ "$( test_archive_contents )" = "${expected}" ]
}

@test "error during archiving files" {
  # Remove all permissions to create error
  chmod 000 "${TEST_FILE}"

  run add_to_archive "${TEST_FILE}" 0 "${TEST_ARCHIVE_TAR}"

  [ -f ${TEST_FILE} ]
  [ -d ${TEST_DIR} ]
  [ "${lines[0]}" = "tar: test.txt: Cannot open: Permission denied" ]
  [ -z "$( test_archive_contents )" ]
}

@test "unarchiving files from archive" {
  rm -rf "${FIXTURES_DIR}/test_dir"

  output="$( unarchive "test_dir" 0 "${FIXTURES_DIR}/dummy_archive.tar" )"

  local actual_contents="$( tar -tf "${FIXTURES_DIR}/dummy_archive.tar" )"
  local expected_contents="test.txt
test_dir/
test_dir/test1.txt"

  [ "${output}" = "Retrieved test_dir from archive" ]
  [ "${actual_contents}" = "${expected_contents}" ]
  [ -f "${FIXTURES_DIR}/test_dir/test1.txt" ]
  [ -d "${FIXTURES_DIR}/test_dir" ]
}


@test "unarchiving files followed by removing from archive" {
  cp "${FIXTURES_DIR}/dummy_archive.tar" "${TEST_ARCHIVE_TAR}"

  local output="$( unarchive "test_dir" 1 "${TEST_ARCHIVE_TAR}" )"
  local expected_output="Retrieved test_dir from archive
Deleted test_dir from archive permanently"

  local actual_contents="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected_contents="test.txt"

  [ "${output}" = "${expected_output}" ]
  [ "$( test_archive_contents )" = "${expected_contents}" ]
  [ -f "${BATS_TMPDIR}/test_dir/test1.txt" ]
  [ -d "${TEST_DIR}" ]
}
