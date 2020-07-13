function define_paths() {
  PROJECT_ROOT="${BATS_TEST_DIRNAME}/../.."
  FIXTURES_DIR="${PROJECT_ROOT}/test/fixtures"
}

function print_test_debug_info() {
  echo "Actual: ${actual}"
  echo "Expected: ${expected}"
}
