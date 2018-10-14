#!/bin/bash

GH_BASE_DIR=${GH_BASE_DIR:-$HOME/src}

# Usage: gh gl namespace repo
function gh() {
  if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo "USAGE: gh [host:-github.com] [user] [repo]"
    return
  fi

  host=$1
  user=$2
  repo=$3

  if [[ $# == 2 ]]; then
    host="gh"
    user=$1
    repo=$2
  fi

  case "$host" in
    "gh") host="github.com"
    ;;
    "gl") host="gitlab.com"
    ;;
    "bb") host="bitbucket.org"
    ;;
    *) host="$host"
    ;;
  esac

  user_path=$GH_BASE_DIR/$host/$user
  local_path=$user_path/$repo

  if [[ ! -d $local_path ]]; then
    git clone git@$host:$user/$repo.git $local_path
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
