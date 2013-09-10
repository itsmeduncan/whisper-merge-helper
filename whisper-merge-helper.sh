#!/bin/bash

whisper_cmd="whisper-merge.py"
target_directory=""
source_directory=""
namespace=""
hostname="localhost"
port="8126"
debug=""
forced=""

usage()
{
  echo "$(basename "$0") -- program help with merging StatsD whisper stores

  where:
    -?  show this help text
    -s  source_directory (example: /mnt/storage/api)
    -t  target_directory (example: /mnt/storage/api/v1)
    -n  StatsD namespace to cleanup
    -p  StatsD TCP interface (default: $port)
    -h  StatsD TCP hostname (default: $hostname)
    -c  Command to run (default: $whisper_cmd)
    -f  Force run. Do not exit on error
    -d  Dry run, and output debug information"
}

while getopts "?:t:s:n:h:c:p:df" opt; do
  case "$opt" in
    \?) usage; exit 0 ;;
    t) target_directory=${OPTARG%/} ;;
    s) source_directory=${OPTARG%/} ;;
    n) namespace=$OPTARG ;;
    h) hostname=$OPTARG ;;
    p) port=$OPTARG ;;
    c) whisper_cmd=$OPTARG ;;
    d) debug="true" ;;
    f) forced="true";;
  esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [ -z $target_directory ] && [ -d $target_directory ]; then
  usage; exit 1
fi

if [ -z $source_directory ] && [ -d $source_directory ]; then
  usage; exit 1
fi

if [ -z $namespace ] && [ -d $namespace ]; then
  usage; exit 1
fi

if [ -z $hostname ]; then
  usage; exit 1
fi

if [ -z $port ]; then
  usage; exit 1
fi

run_cmd()
{
  if [ "$debug" == "true" ]; then
    echo "Dry run: $1"
  else
    eval "$1"
    if [ $? -ne 0 ]; then
      echo "$1 failed!"
      if [ "$forced" != "true" ]; then exit 1; fi
    fi
  fi
}

run_cmd "$whisper_cmd $source_directory/count.wsp $target_directory/count.wsp"
run_cmd "$whisper_cmd $source_directory/rate.wsp $target_directory/rate.wsp"
run_cmd "echo 'delcounters $namespace' | nc $hostname $port"
run_cmd "rm -r $source_directory"