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
    filter_top_level_files "$(tar -t -f "${archive}")"
  else
    echo "No archive file in current directory"
  fi
}


# ===================
#  Private functions
# ===================


# $1: list of files
filter_top_level_files() {
  files="$1"

  for file in ${files}; do
    slash_count="$( echo "${file}" | grep -Ec '/' )"

    is_top_level_file="$( test "${slash_count}" -eq 0; echo "$?" )"
    is_top_level_dir="$( test "${slash_count}" -eq 1 && 
                         ends_with "${file}" '/'; echo "$?" )"

    if [ "${is_top_level_file}" -eq 0 ] || [ "${is_top_level_dir}" -eq 0 ]; then
      echo "${file}"
    fi
  done
}

ends_with() {
  string="$1"
  ends_with="$2"

  echo "${string}" | grep -qE "${ends_with}\$"
}
