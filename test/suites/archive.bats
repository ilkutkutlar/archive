#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/defaults.sh"
  source "${PROJECT_ROOT}/lib/archive.sh"

  TEST_ARCHIVE_TAR="${BATS_TMPDIR}/${ARCHIVE_TAR}"
  TEST_FILE="${BATS_TMPDIR}/test.txt"
  TEST_DIR="${BATS_TMPDIR}/test_dir"
}

function remove_old_test_archive() {
  rm -f "${TEST_ARCHIVE_TAR}"
}

function create_test_files() {
  touch "${TEST_FILE}"
  mkdir -p "${TEST_DIR}"
  touch "${TEST_DIR}/test1.txt"
}

@test "archiving files" {
  remove_old_test_archive
  create_test_files

  output_1="$( add "${TEST_FILE}" 0 "${TEST_ARCHIVE_TAR}" )"
  output_2="$( add "${TEST_DIR}" 0 "${TEST_ARCHIVE_TAR}" )"
  
  local actual_contents="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected_contents="$( basename ${BATS_TMPDIR} )/test.txt
$( basename ${BATS_TMPDIR} )/test_dir/
$( basename ${BATS_TMPDIR} )/test_dir/test1.txt"

  local expected_output=""

  [ -f ${TEST_FILE} ]
  [ -d ${TEST_DIR} ]
  [ "${output_1}" = "${TEST_FILE} added to archive" ]
  [ "${output_2}" = "${TEST_DIR} added to archive" ]
  [ "${actual_contents}" = "${expected_contents}" ]
}

@test "moving files - archiving and removing" {
  remove_old_test_archive
  create_test_files

  output_1="$( add "${TEST_FILE}" 1 "${TEST_ARCHIVE_TAR}" )"
  output_2="$( add "${TEST_DIR}" 1 "${TEST_ARCHIVE_TAR}" )"
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test.txt
$( basename ${BATS_TMPDIR} )/test_dir/
$( basename ${BATS_TMPDIR} )/test_dir/test1.txt"

  [ ! -f ${TEST_FILE} ]
  [ ! -d ${TEST_DIR} ]
  [ "${output_1}" = "${TEST_FILE} added to archive" ]
  [ "${output_2}" = "${TEST_DIR} added to archive" ]
  [ "${actual}" = "${expected}" ]
}

@test "unarchiving files from archive" {
  rm -rf "${FIXTURES_DIR}/test_dir"
  output="$( unarchive "test_dir" "${FIXTURES_DIR}/list_test_archive.tar" )"

  [ "${output}" = "Retrieved ${test_dir} from archive" ]
  [ -f "${FIXTURES_DIR}/test_dir/test1.txt" ]
  [ -d "${FIXTURES_DIR}/test_dir" ]
}

@test "removing files from archive" {
  TEST_TAR="${FIXTURES_DIR}/remove_test_archive.tar"
  rm -f "${TEST_TAR}"
  
  cp "${FIXTURES_DIR}/list_test_archive.tar" "${TEST_TAR}"
  output="$( remove_from_archive "test_dir" "${TEST_TAR}" )"

  local actual="$( tar -tf "${TEST_TAR}" )"
  local expected="test.txt"

  [ "${output}" = "Remove ${test_dir} from archive permanently" ]
  [ "${actual}" = "${expected}" ]
}
