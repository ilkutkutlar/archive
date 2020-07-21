function define_paths() {
  readonly PROJECT_ROOT="${BATS_TEST_DIRNAME}/../.."
  readonly FIXTURES_DIR="${PROJECT_ROOT}/test/fixtures"

  readonly TEST_ARCHIVE_TAR="${BATS_TMPDIR}/test_archive.tar"
  readonly TEST_DIR="${BATS_TMPDIR}/test_dir"
  readonly TEST_FILE="${BATS_TMPDIR}/test.txt"

  readonly DUMMY_ARCHIVE="${FIXTURES_DIR}/dummy_archive.tar"
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
