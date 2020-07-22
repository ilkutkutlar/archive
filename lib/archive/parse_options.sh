# Sets global variables:
# $action: action specified by the user
# $file (optional): file to act on 
# $remove_files: (optional) whether to remove
#                file after performing action.
#                0 or 1.
#
# $@: all options to be parsed
parse_options() {
  action=
  file=
  remove_files=0

  set -- "$@"

  while [ -n "$1" ]; do
    opt="$1"
    temp_action=

    case "${opt}" in
      -a | --add) 
        temp_action="${ACTION_ADD}"
        shift

        if [ -z "$1" ]; then
          echo "No file argument given to '-a/--add' option"
          echo
          return 1
        fi
        
        # shellcheck disable=SC2034
        file="$1"
        ;;
      -u | --unarchive) 
        temp_action="${ACTION_UNARCHIVE}" 
        shift

        if [ -z "$1" ]; then
          echo "No file argument given to '-u/--unarchive' option"
          echo
          return 1
        fi
        
        # shellcheck disable=SC2034
        file="$1"
        ;;
      -d | --delete)
        # shellcheck disable=SC2034
        remove_files=1 ;;
      -l | --list) temp_action="${ACTION_LIST}" ;;
      -t | --top-level) temp_action="${ACTION_TOP_LEVEL_LIST}" ;;
      -h | --help) temp_action="${ACTION_HELP}" ;;
      -v | --version) temp_action="${ACTION_VERSION}" ;;
      *) return 1 ;;
    esac

    if [ -n "${temp_action}" ] && ! set_action "${temp_action}"; then 
      return 1
    fi

    shift
  done
}


# ===================
#  Private functions
# ===================


set_action() {
  if [ -n "${action}" ]; then
    echo "Incorrect set of options given"
    echo
    return 1
  fi

  action="$1"
}
