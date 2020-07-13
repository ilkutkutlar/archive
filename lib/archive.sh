# $1: file to archive
# $2: remove file after adding to archive, 1 or 0
# $3: optional: add file to custom archive, defaults to ./$ARCHIVE_TAR
add() {
  filename="$1"
  remove_files="$2"
  archive=${3-"./${ARCHIVE_TAR}"}
  
  if [ ! -e "${filename}" ]; then
    echo "No such file: ${filename}"
    return 1
  fi

  if [ "${remove_files}" -eq 1 ]; then
    tar -r "${filename}" -f "${archive}" --remove-files
  else
    tar -r "${filename}" -f "${archive}"
  fi

  if [ "$?" ]; then
    echo "${filename} added to archive"
  else
    echo "Adding to archive failed"
  fi
}

usage() {
  echo "Usage: $0 [option] [file]"
  echo "v0.0.1 - Ilkut Kutlar - July 2020"
}

help() {
  usage
  
  echo
  echo '  -a, --add       add file to archive of current directory'
  echo '  -m, --move      add file to archive and remove it'
  echo '  -l, --list      list the files in current directory archive'
  echo '  -v, --version   print version and exit'
  echo '  -h, --help      print this help and exit'
}
