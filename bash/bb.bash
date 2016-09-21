function bb() {
  if [[ $# -ne 2 ]]; then
    echo "USAGE: bb [user] [repo]"
    return
  fi

  user=$1
  repo=$2

  user_path=$HOME/src/bitbucket.org/$user
  local_path=$user_path/$repo

  if [[ ! -d $local_path ]]; then
    git clone git@bitbucket.org:$user/$repo.git $local_path
  fi

  # If git exited uncleanly, clean up the created user directory (if exists)
  # and don't try to `cd` into it.

  if [[ $? -ne 0 ]]; then
    if [[ -d $user_path ]]; then
      rm -d $user_path
    fi
  else
    cd $local_path
  fi
}
