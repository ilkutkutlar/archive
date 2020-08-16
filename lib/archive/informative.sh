# $1: optional: list custom archive, defaults to ./$ARCHIVE_TAR
list() {
  archive=${1-"./${ARCHIVE_TAR}"}
  
  if [ -e "${archive}" ]; then
    echo "Files in archive:"
    tar -t -f "${archive}"
  else
    echo "No archive file in current directory"
  fi
}

# $1: optional: list custom archive, defaults to ./$ARCHIVE_TAR
list_top_level() {
  archive=${1-"./${ARCHIVE_TAR}"}
  
  if [ -e "${archive}" ]; then
    echo "Top-level files in archive:"
    filter_top_level_files "$( tar -t -f "${archive}" )"
  else
    echo "No archive file in current directory"
  fi
}


# ===================
#  Private functions
# ===================


# $1: list of file paths
filter_top_level_files() {
  file_paths="$1"

  for file in ${file_paths}; do
    if is_top_level "${file}"; then
      echo "${file}"
    fi
  done
}

is_top_level() {
  file_path="$1"

  # By definition, current directory, ".", 
  # is the dirname of a top-level file.
  test "$( dirname "${file_path}" )" = "." 
}
