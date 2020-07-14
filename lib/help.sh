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
