usage() {
  echo "Usage:"
  echo "  $(basename "$0") -a file [-d]"
  echo "  $(basename "$0") {-l|-v|-h}"
  echo "v0.0.1 - Ilkut Kutlar - July 2020"
}

help() {
  usage
  
  echo
  echo '  -a    add file to archive of current directory'
  echo '  -m    add file to archive and remove it'
  echo '  -l    list the files in current directory archive'
  echo '  -v    print version and exit'
  echo '  -h    print this help and exit'
}
