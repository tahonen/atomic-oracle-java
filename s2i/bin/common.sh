# common shell routines for s2i scripts


function find_env() {
  local var=${!1}
  echo "${var:-$2}"
}



# copy all artifacts of types, specified as the second up to n-th
# argument of the routine into the $DEPLOY_DIR directory
# Requires: source directory expressed in the form of absolute path!
function copy_artifacts() {
  dir=$1
  types=
  shift
  while [ $# -gt 0 ]; do
    types="$types;$1"
    shift
  done

  for d in $(echo $dir | tr "," "\n")
  do
    shift
    local regex="^\/"
    if [[ ! "$d" =~ $regex ]]; then
      echo "$FUNCNAME: Absolute path required for source directory \"$d\"!"
      exit 1
    fi
    for t in $(echo $types | tr ";" "\n")
    do
      echo "Copying all $t artifacts from $d directory into $DEPLOY_DIR for later deployment..."
      cp -rfv $d/*.$t $DEPLOY_DIR 2> /dev/null
    done
  done
}
