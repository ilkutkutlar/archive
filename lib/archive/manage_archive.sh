# Add file to given archive.
#
# $1: file path to archive
# $2: remove file after adding to archive, 1 or 0
# $3: optional: add file to custom archive, defaults to ./$ARCHIVE_TAR
add_to_archive() {
  file_path="$1"
  file_name="$( basename "$1" )"
  file_dir="$( dirname "$1" )"

  remove_files="$2"
  archive=${3-"./${ARCHIVE_TAR}"}
  
  if [ ! -e "${file_path}" ]; then
    echo "No such file: ${file_path}"
    return 1
  fi

  if [ "${remove_files}" -eq 1 ]; then
    # tar will complain if file path is absolute. To avoid it,
    # change to file's directory and add file by it's basename.
    tar -C "${file_dir}" -r "${file_name}" -f "${archive}" --remove-files
  else
    tar -C "${file_dir}" -r "${file_name}" -f "${archive}"
  fi

  if [ "$?" -eq 0 ]; then
    echo "${file_path} added to archive"
  else
    echo "Adding to archive failed"
  fi
}

# Gzip file and add to given archive.
#
# $1: file path to archive
# $2: optional: add file to custom archive, defaults to ./$ARCHIVE_TAR
add_to_archive_gzipped() {
  file_path="$1"
  file_dir="$( dirname "$1" )"
  archive=${2-"./${ARCHIVE_TAR}"}
  
  if [ ! -e "${file_path}" ]; then
    echo "No such file: ${file_path}"
    return 1
  fi

  gzipped_file_name="$( gzip_file_or_dir "${file_path}" )"
  if [ -z "${gzipped_file_name}" ]; then
    # gzip_file_or_dir will echo an appropriate error message;
    # just return the exit status here
    return 1
  fi

  # Remove the gzipped file as it is only temporary.
  # There is no option to remove the original file when gzipping. 
  tar -C "${file_dir}" -r "${gzipped_file_name}" -f "${archive}" --remove-files

  if [ "$?" -eq 0 ]; then
    echo "${file_path} added to archive as a gzipped file named ${gzipped_file_name}"
  else
    echo "Adding to archive failed"
  fi
}

# Unarchives file from given archive file. 
# File is extracted into the same directory 
# as the archive file.
#
# $1: file to unarchive
# $2: remove from archive after unarchiving, 1 or 0
# $3: optional: unarchive file from this archive,
#     defaults to ./$ARCHIVE_TAR
unarchive() {
  file_path="$1"
  remove_files="$2"
  archive=${3-"./${ARCHIVE_TAR}"}
  archive_dir="$( dirname "${archive}" )"

  # Change to archive's directory, so that the unarchived
  # file is placed inside the archive's directory instead of CWD.
  tar -C "${archive_dir}" -x -f "${archive}" "${file_path}"

  if [ "$?" -eq 0 ] && [ -e "${archive_dir}/${file_path}" ]; then
    echo "Retrieved ${file_path} from archive" 
  else
    echo "Retrieving from archive failed"
    exit 1
  fi

  if [ "${remove_files}" -eq 1 ]; then
    destroy_file_in_archive "${file_path}" "${archive}"
  fi
}


# ===================
#  Private functions
# ===================


# $1: file path (in archive) to delete from archive
# $2: optional: delete file from this archive, 
#     defaults to ./$ARCHIVE_TAR
destroy_file_in_archive() {
  file_path="$1"
  archive=${2-"./${ARCHIVE_TAR}"}
  archive_dir="$( dirname "${archive}" )"
  
  tar -C "${archive_dir}" -f "${archive}" --delete "${file_path}"

  if [ "$?" -eq 0 ]; then
    echo "Deleted ${file_path} from archive permanently"
  else
    echo "Deleting from archive failed"
  fi
}

# Gzip the given file. If it's a file, then it will be gzipped
# directly. If it's a directory, the directory will be tarred
# and gzipped (i.e. .tar.gz). In both cases, the original
# file will not be removed and the gzipped file will be in
# the same directory as the original file.
# 
# $1: file path
# Echoes file name of gzipped file/dir if successful.
# Echoes nothing on error.
gzip_file_or_dir() {
  file_path="$1"
  file_name="$( basename "${file_path}" )"
  file_dir="$( dirname "${file_path}" )"

  if [ -f "${file_path}" ]; then
    # -k to keep the original file.
    gzip -k "${file_path}"

    if [ "$?" -eq 0 ] || gzip -t "${file_path}.gz"; then
      echo "${file_name}.gz"
    fi
  else
    # Use file_path instead of file_name here, so that it creates
    # the archive in the same directory as the file.
    tar -C "${file_dir}" -czf "${file_path}.tar.gz" "${file_name}"

    if [ "$?" -eq 0 ] || gzip -t "${file_path}.tar.gz"; then
      echo "${file_name}.tar.gz"
    fi
  fi
}
