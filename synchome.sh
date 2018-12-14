#!/bin/bash

# synchome.sh
# Copyright (C) 2015 Benjamin Abendroth
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

rsnyc_dry_opt=''
log_file="/tmp/synchome.log"
exclude_file=''
union_dir=''
perm_dir=''

_help() {
   cat << EOF
$0 [OPTIONS]

   OPTIONS:
      --help|-h
         Show this help text.

      --dry
         Just write log file, don't sync

      --exclude-file
         Set exclude file

      --union-dir
         Set unionfs-mountpoint

      --perm-dir
         Set persistent storage dir

      --log-file
         Use alternative log file (default=$log_file)
EOF
   exit 0
}

#
# "Function" for getting an argument.
# Manipulating the scripts argument list is not possible inside a function.
# Throwing the scripts arguments into an array would be too much work ;)
#
_getarg='
   if (( $# == 0 )); then
      echo "missing argument for $opt" >&2;
      exit 1;
   fi

   opt_arg=$1;
   shift
'

check_option() {
   if ! [[ "${!1}" ]]; then
      echo "option $2 not set" >&2
      exit 1;
   fi
}

while (( "$#" > 0 )); do
   opt=$1; shift

   case "$opt" in
      "--help"|"-h")
         _help;;

      "--dry"|"--dry-run")
         rsnyc_dry_opt='--dry-run';;

      "--log-file")
         eval "$_getarg" || exit 1
         log=$opt_arg;;

      "--exclude-file")
         eval "$_getarg" || exit 1
         exclude_file=$opt_arg;;

      "--union-dir")
         eval "$_getarg" || exit 1
         union_dir=$opt_arg;;

      "--perm-dir")
         eval "$_getarg" || exit 1
         perm_dir=$opt_arg;;

      *)
         echo "Unknown option: $opt";
         exit 1;;
   esac
done

check_option exclude_file --exclude-file
check_option union_dir --union-dir
check_option perm_dir --perm-dir

(( $UID )) && {
   echo "$0: need to be root";
   exit 1;
}

rm -f "$log_file"

rsync $rsnyc_dry_opt \
	-a \
	--delete \
	--verbose \
   --exclude-from="$exclude_file" \
	"$union_dir/" "$perm_dir" | tee -a "$log_file"

echo "Log file is $log_file" >&2
echo " (you may run clean-union-tmpfs now to remove old files from RAM/tmpfs)" >&2
