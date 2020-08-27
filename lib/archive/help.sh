usage() {
  echo "v0.0.3 - August 2020"
  echo "Usage: $(basename "$0") {-a|-u} file [-d]"
  echo "       $(basename "$0") -z file"
  echo "       $(basename "$0") {-h|-l|-t|-v}"
}

help() {
  usage
  
  echo
  echo '  -a, --add FILE          Add file to archive of current directory'
  echo '  -u, --unarchive FILE    Unarchive file from archive of current directory'
  echo '  -d, --delete            Pass flag to -a or -u (but not -z) to delete file in dir/archive after operation'
  echo '  -z, --add-gzipped FILE  Add a gzipped version of file to archive. Original file is not affected.'
  echo '  -l, --list              List the files in current directory archive'
  echo '  -t, --top-level         List only top-level files and directories in current directory archive'
  echo '  -v, --version           Print version and exit'
  echo '  -h, --help              Print this help and exit'
}
