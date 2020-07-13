#!/usr/bin/env bats

function setup() {
  export PROJECT_ROOT="${BATS_TEST_DIRNAME}/../.."
  source "${PROJECT_ROOT}/lib/archive.sh"

  export FIXTURES_DIR="${PROJECT_ROOT}/test/fixtures"
}

function print_test_debug_info() {
  echo "Actual: ${actual}"
  echo "Expected: ${expected}"
}

@test "archiving file" {
  TEST_ARCHIVE_TAR="${BATS_TMPDIR}/${ARCHIVE_TAR}"
  rm -f "${TEST_ARCHIVE_TAR}"

  TEST_FILE="${BATS_TMPDIR}/test.txt"
  touch "${TEST_FILE}"

  add "${TEST_FILE}" 0 "${TEST_ARCHIVE_TAR}" > /dev/null 2>&1
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test.txt"
  print_test_debug_info

  [ "${actual}" = "${expected}" ] && [ -f ${TEST_FILE} ]
}

@test "archiving directory" {
  TEST_ARCHIVE_TAR="${BATS_TMPDIR}/${ARCHIVE_TAR}"
  rm -f "${TEST_ARCHIVE_TAR}"

  TEST_DIR="${BATS_TMPDIR}/test_dir"
  mkdir -p "${TEST_DIR}"
  touch "${TEST_DIR}/test1.txt"

  add "${TEST_DIR}" 0 "${TEST_ARCHIVE_TAR}" > /dev/null 2>&1
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test_dir/
$( basename ${BATS_TMPDIR} )/test_dir/test1.txt"
  print_test_debug_info

  [ "${actual}" = "${expected}" ] && [ -d ${TEST_DIR} ]
}

@test "moving file - archiving and removing" {
  TEST_ARCHIVE_TAR="${BATS_TMPDIR}/${ARCHIVE_TAR}"
  rm -f "${TEST_ARCHIVE_TAR}"

  TEST_FILE="${BATS_TMPDIR}/test.txt"
  touch "${TEST_FILE}"

  add "${TEST_FILE}" 1 "${TEST_ARCHIVE_TAR}" > /dev/null 2>&1
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test.txt"
  print_test_debug_info

  [ "${actual}" = "${expected}" ] && [ ! -f ${TEST_FILE} ]
}

@test "moving directory - archiving and removing" {
  TEST_ARCHIVE_TAR="${BATS_TMPDIR}/${ARCHIVE_TAR}"
  rm -f "${TEST_ARCHIVE_TAR}"

  TEST_DIR="${BATS_TMPDIR}/test_dir"
  mkdir -p "${TEST_DIR}"
  touch "${TEST_DIR}/test1.txt"

  add "${TEST_DIR}" 1 "${TEST_ARCHIVE_TAR}" > /dev/null 2>&1
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/test_dir/
$( basename ${BATS_TMPDIR} )/test_dir/test1.txt"
  print_test_debug_info

  [ "${actual}" = "${expected}" ] && [ ! -d ${TEST_DIR} ]
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
