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
