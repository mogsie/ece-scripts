#! /usr/bin/env bash

# removes log files older than three days
max_days_old=3

function get_log_file_dir_list() {
  local dir_list="${log_dir}"

  local dir=${tomcat_base}/logs
  if [ -d $dir ]; then
    dir_list="${dir_list} ${dir}"
  fi

  echo $dir_list
}

function remove_old_logs_if_exist() {
  debug "Looking for old log files in $1 ..."
  
  local old_log_files="$(
    find -L $1 -mtime +${max_days_old} -type f
  )"

  if [ -z $old_log_files ]; then
    return
  fi

  print "Deleting" $(echo "$old_log_files" | wc -l) "old log files in $1 ..."
  run rm $old_log_files
}

function remove_old_log_files() {
  local dir_list=$(get_log_file_dir_list)

  for el in $dir_list; do
    remove_old_logs_if_exist $el
  done
}
