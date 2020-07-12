#!/usr/bin/env bats

function setup() {
  export PROJECT_ROOT="${BATS_TEST_DIRNAME}/../.."
  source "${PROJECT_ROOT}/lib/archive.sh"

  export TEST_ARCHIVE_TAR="${BATS_TMPDIR}/${ARCHIVE_TAR}"
}

@test "archiving single file" {
  local TEST_FILE="test.txt"
  local TEST_FILE_PATH="${BATS_TMPDIR}/${TEST_FILE}"
  rm "${TEST_ARCHIVE_TAR}"
  touch "${TEST_FILE_PATH}"

  add "${TEST_FILE_PATH}" "${BATS_TMPDIR}" 0 > /dev/null 2>&1
  
  local actual="$( tar -tf "${TEST_ARCHIVE_TAR}" )"
  local expected="$( basename ${BATS_TMPDIR} )/${TEST_FILE}"
  echo "Actual files in archive: ${actual}"
  echo "Expected files in archive: ${expected}"
  [ "${actual}" = "${expected}" ]
}
