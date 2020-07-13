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

  add "${TEST_FILE}" 0 "${TEST_ARCHIVE_TAR}"
  add "${TEST_DIR}" 0 "${TEST_ARCHIVE_TAR}"
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test.txt
$( basename ${BATS_TMPDIR} )/test_dir/
$( basename ${BATS_TMPDIR} )/test_dir/test1.txt"
  print_test_debug_info "${actual}" "${expected}"

  [ "${actual}" = "${expected}" ] && [ -f ${TEST_FILE} ] && [ -d ${TEST_DIR} ]
}

@test "moving files - archiving and removing" {
  remove_old_test_archive
  create_test_files

  add "${TEST_FILE}" 1 "${TEST_ARCHIVE_TAR}"
  add "${TEST_DIR}" 1 "${TEST_ARCHIVE_TAR}"
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test.txt
$( basename ${BATS_TMPDIR} )/test_dir/
$( basename ${BATS_TMPDIR} )/test_dir/test1.txt"
  print_test_debug_info "${actual}" "${expected}"

  [ "${actual}" = "${expected}" ] && [ ! -f ${TEST_FILE} ] && [ ! -d ${TEST_DIR} ]
}

@test "unarchiving files from archive" {
  rm -rf "${FIXTURES_DIR}/test_dir"
  unarchive "test_dir" "${FIXTURES_DIR}/list_test_archive.tar"
  [ -d "${FIXTURES_DIR}/test_dir" ] && [ -f "${FIXTURES_DIR}/test_dir/test1.txt" ]
}

@test "removing files from archive" {
  TEST_TAR="${FIXTURES_DIR}/remove_test_archive.tar"
  rm -f "${TEST_TAR}"
  
  cp "${FIXTURES_DIR}/list_test_archive.tar" "${TEST_TAR}"
  remove_from_archive "test_dir" "${TEST_TAR}"

  local actual="$( tar -tf "${TEST_TAR}" )"
  local expected="test.txt"
  print_test_debug_info "${actual}" "${expected}"

  [ "${actual}" = "${expected}" ]
}
