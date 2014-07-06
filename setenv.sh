#!/bin/bash

usage() {
    echo "Usage: source setenv.sh { -k PRIVATEKEY | -h HOST }"
    exit
}

for OPT in "$@"
do
    case "$OPT" in
        '--help' )
            usage
            exit 1
            ;;
        '-k'|'--key' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option requires an argument -- $1" 1>&2
                exit 1
            fi
            DEFAULT_PRIVATEKEY="$2"
            shift 2
            ;;
        '-h'|'--host' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option requires an argument -- $1" 1>&2
                exit 1
            fi
            DEFAULT_HOST="$2"
            shift 2
            ;;
        '--'|'-' )
            shift 1
            param+=( "$@" )
            break
            ;;
        -*)
            echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
            exit 1
            ;;
        *)
            if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                #param=( ${param[@]} "$1" )
                param+=( "$1" )
                shift 1
            fi
            ;;
    esac
done

if [ ! "${DEFAULT_PRIVATEKEY}" = "" ];then
  export DEFAULT_PRIVATEKEY
  echo "DEFAULT_PRIVATEKEY=${DEFAULT_PRIVATEKEY}"
fi

if [ ! "${DEFAULT_HOST}" = "" ];then
  export DEFAULT_HOST
  echo "DEFAULT_HOST=${DEFAULT_HOST}"
fi
