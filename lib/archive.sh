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
  remove_files=

  while getopts 'a:dlhv' opt; do
    case "${opt}" in
      a) 
        set_action add
        file="${OPTARG}"
        ;;
      d) remove_files=1 ;;
      l) set_action list ;;
      h) set_action help ;;
      v) set_action usage ;;
      *) set_action help ;;
    esac
  done

  # shellcheck disable=SC2034
  readonly action file remove_files
}


# ===================
#  Private functions
# ===================


set_action() {
  if [ -n "${action}" ]; then
    echo "Incorrect set of options given"
    echo
    usage
    exit 1
  fi

  action="$1"
}
