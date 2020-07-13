#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/defaults.sh"
  source "${PROJECT_ROOT}/lib/archive.sh"

  export TEST_ARCHIVE_TAR="${BATS_TMPDIR}/${ARCHIVE_TAR}"
}

function remove_old_test_archive() {
  rm -f "${TEST_ARCHIVE_TAR}"
}

@test "archiving file" {
  remove_old_test_archive
  TEST_FILE="${BATS_TMPDIR}/test.txt"
  touch "${TEST_FILE}"

  add "${TEST_FILE}" 0 "${TEST_ARCHIVE_TAR}" > /dev/null 2>&1
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test.txt"
  print_test_debug_info "${actual}" "${expected}"

  [ "${actual}" = "${expected}" ] && [ -f ${TEST_FILE} ]
}

@test "archiving directory" {
  remove_old_test_archive
  TEST_DIR="${BATS_TMPDIR}/test_dir"
  mkdir -p "${TEST_DIR}"
  touch "${TEST_DIR}/test1.txt"

  add "${TEST_DIR}" 0 "${TEST_ARCHIVE_TAR}" > /dev/null 2>&1
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test_dir/
$( basename ${BATS_TMPDIR} )/test_dir/test1.txt"
  print_test_debug_info "${actual}" "${expected}"

  [ "${actual}" = "${expected}" ] && [ -d ${TEST_DIR} ]
}

@test "moving file - archiving and removing" {
  remove_old_test_archive
  TEST_FILE="${BATS_TMPDIR}/test.txt"
  touch "${TEST_FILE}"

  add "${TEST_FILE}" 1 "${TEST_ARCHIVE_TAR}" > /dev/null 2>&1
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test.txt"
  print_test_debug_info "${actual}" "${expected}"

  [ "${actual}" = "${expected}" ] && [ ! -f ${TEST_FILE} ]
}

@test "moving directory - archiving and removing" {
  remove_old_test_archive
  TEST_DIR="${BATS_TMPDIR}/test_dir"
  mkdir -p "${TEST_DIR}"
  touch "${TEST_DIR}/test1.txt"

  add "${TEST_DIR}" 1 "${TEST_ARCHIVE_TAR}" > /dev/null 2>&1
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test_dir/
$( basename ${BATS_TMPDIR} )/test_dir/test1.txt"
  print_test_debug_info "${actual}" "${expected}"

  [ "${actual}" = "${expected}" ] && [ ! -d ${TEST_DIR} ]
}

@test "unarchiving file from archive" {
  rm -rf "${FIXTURES_DIR}/test_dir"
  unarchive "test_dir" "${FIXTURES_DIR}/list_test_archive.tar"
  [ -d "${FIXTURES_DIR}/test_dir" ] && [ -f "${FIXTURES_DIR}/test_dir/test1.txt" ]
}

@test "removing file from archive" {
  TEST_TAR="${FIXTURES_DIR}/remove_test_archive.tar"
  rm -f "${TEST_TAR}"
  
  cp "${FIXTURES_DIR}/list_test_archive.tar" "${TEST_TAR}"
  remove_from_archive "test_dir" "${TEST_TAR}"

  local actual="$( tar -tf "${TEST_TAR}" )"
  local expected="test.txt"
  print_test_debug_info "${actual}" "${expected}"

  [ "${actual}" = "${expected}" ]
}
