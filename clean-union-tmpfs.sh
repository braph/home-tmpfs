#!/bin/bash

unset CDPATH
set -u +o histexpand

#
# Script writes out what should be done.
# Pipe to |sh to execute it
#

if [[ "${1:-}" == "--script-sub" ]]; then
   shift
   tmpfs_dir=$1
   perm_dir=$2
   file=$3
   perm_dir_file="${file/$tmpfs_dir/$perm_dir}"

   echo "# check: $file"

   if [[ -d "$file" ]]; then
      if [[ -d "$perm_dir_file" ]]; then
         printf "rmdir %q\n" "$file"
      else
         echo "# wont rmdir $file"
      fi
   elif ! cmp -s "$file" "$perm_dir_file" >/dev/null 2>/dev/null; then
      echo "# wont copy $file"
   else
      printf "rm -v %q\n" "$file"
   fi
else
   tmpfs_dir=${1:?"tmpfs_dir not set"}
   perm_dir=${2:?"perm_dir not set"}

   find "$tmpfs_dir" -type f -exec "$0" --script-sub "$1" "$2" {} \;
   find "$tmpfs_dir" -type d -exec "$0" --script-sub "$1" "$2" {} \;
fi
