#!/usr/bin/env bats

load test_helper

function setup() {
  define_paths
  source "${PROJECT_ROOT}/lib/archive/manage_archive.sh"
  
  remove_old_test_archive
  remove_old_test_files
  create_test_files
}

@test "archiving files in gzipped format" {
  # Files are compressed with `gzip` and have extension .gz
  # Directories are compressed with `tar` as a .tar.gz

  run add_to_archive_gzipped "${TEST_FILE}" 0 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${TEST_FILE} added to archive as a gzipped file named test.txt.gz" ]
  [ "${status}" -eq 0 ]

  run add_to_archive_gzipped "${TEST_DIR}" 0 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${TEST_DIR} added to archive as a gzipped file named test_dir.tar.gz" ]
  [ "${status}" -eq 0 ]

  [ -f "${TEST_FILE}" ]
  # The gzipped files are temporary: must be removed after adding.
  [ ! -f "${TEST_FILE}.gz" ]

  [ -d "${TEST_DIR}" ]
  [ ! -d "${TEST_DIR}.tar.gz" ]

  # TODO: While we can reasonably assume these test files being in
  # TODO: the archive proves gzipping worked as expected, a better 
  # TODO: test could have fixtures which are gzipped versions of these
  # TODO: test files and compare them to the ones in the archive.
  local expected_contents="test.txt.gz
test_dir.tar.gz"
  assert_test_archive_contents "${expected_contents}"
}

@test "archiving files in gzipped format followed by removing" {
  # Files are compressed with `gzip` and have extension .gz
  # Directories are compressed with `tar` as a .tar.gz

  run add_to_archive_gzipped "${TEST_FILE}" 1 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${TEST_FILE} added to archive as a gzipped file named test.txt.gz" ]
  [ "${status}" -eq 0 ]

  run add_to_archive_gzipped "${TEST_DIR}" 1 "${TEST_ARCHIVE_TAR}"
  [ "${output}" = "${TEST_DIR} added to archive as a gzipped file named test_dir.tar.gz" ]
  [ "${status}" -eq 0 ]

  [ ! -f "${TEST_FILE}" ]
  [ ! -f "${TEST_FILE}.gz" ]

  [ ! -d "${TEST_DIR}" ]
  [ ! -d "${TEST_DIR}.tar.gz" ]

  local expected_contents="test.txt.gz
test_dir.tar.gz"
  assert_test_archive_contents "${expected_contents}"
}

@test "error during archiving files in gzipped format" {
  # Remove read permission to create error
  chmod a-r "${TEST_FILE}"

  run add_to_archive_gzipped "${TEST_FILE}" 0 "${TEST_ARCHIVE_TAR}"
  # Unlike with tar, since we are not using the -C option, gzip
  # will show the full path of the file, so it won't only say "test.txt"
  [ "${lines[0]}" = "gzip: ${TEST_FILE}: Permission denied" ]
  [ "${status}" -eq 1 ]

  # TODO: Should be testing for archiving a directory as well.

  [ -f "${TEST_FILE}" ]
  [ ! -f "${TEST_FILE}.gz" ]

  # Error, so archive should be empty
  [ -z "$( test_archive_contents )" ]
}
