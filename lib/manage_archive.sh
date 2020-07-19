# Add file to given archive.
#
# $1: file to archive
# $2: remove file after adding to archive, 1 or 0
# $3: optional: add file to custom archive, defaults to ./$ARCHIVE_TAR
add_to_archive() {
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

# Unarchives file from given archive file. 
# File is extracted into the same directory 
# as the archive file.
#
# $1: file to unarchive
# $2: remove from archive after unarchiving, 1 or 0
# $3: optional: unarchive file from this archive,
#     defaults to ./$ARCHIVE_TAR
unarchive() {
  filename="$1"
  remove_files="$2"
  archive=${3-"./${ARCHIVE_TAR}"}
  archive_dir="$( dirname "${archive}" )"

  tar -x -C "${archive_dir}" -f "${archive}" "${filename}"

  if [ "$?" ] && [ -e "${archive_dir}/${filename}" ]; then
    echo "Retrieved ${filename} from archive" 
  else
    echo "Retrieving from archive failed"
    exit 1
  fi

  if [ "${remove_files}" -eq 1 ]; then
    destroy_archived_file "${filename}" "${archive}"
  fi
}


# ===================
#  Private functions
# ===================


# $1: file to delete from archive
# $2: optional: delete file from this archive, 
#     defaults to ./$ARCHIVE_TAR
destroy_archived_file() {
  filename="$1"
  archive=${2-"./${ARCHIVE_TAR}"}
  archive_dir="$( dirname "${archive}" )"
  
  tar -C "${archive_dir}" -f "${archive}" --delete "${filename}"

  if [ "$?" ]; then
    echo "Deleted ${filename} from archive permanently"
  else
    echo "Deleting file from archive failed"
  fi
}
