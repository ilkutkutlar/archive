readonly ARCHIVE_TAR=".archive.tar"

add() {
  filename="$1"
  remove_files="$2"

  if [ ! -e "${filename}" ]; then
    echo "No such file: ${filename}"
    return 1
  fi

  if [ "${remove_files}" -eq 1 ]; then
    tar -r "${filename}" -f "${ARCHIVE_TAR}" --remove-files
  else
    tar -r "${filename}" -f "${ARCHIVE_TAR}"
  fi

  if [ "$?" ]; then
    echo "${filename} added to archive"
  else
    echo "Adding to archive failed"
  fi
}

list() {
  if [ -e "${ARCHIVE_TAR}" ]; then
    echo "Files in archive: "
    tar -t -f "${ARCHIVE_TAR}"
  else
    echo "No archive file in current directory"
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
