#!/bin/bash

TYPE=$1
PRIVATEKEY=$2
HOST=$3

if [ ! "${TYPE}" = "prod" -a ! "${TYPE}" = "dev" ]; then
  echo "invalid type: ${TYPE}";
  exit -1;
fi

if [ "${PRIVATEKEY}" = "" ]; then
  if [ "${DEFAULT_PRIVATEKEY}" = "" ]; then
    echo "usage: $0 TYPE PRIVATEKEY HOST";
    exit -1;
  else
    PRIVATEKEY=${DEFAULT_PRIVATEKEY}
  fi
fi

if [ ! -f ${PRIVATEKEY} ]; then
  echo "key ${PRIVATEKEY} does not exists";
  exit -1;
fi

if [ "${HOST}" = "" ]; then
  if [ "${DEFAULT_HOST}" = "" ]; then
    echo "usage: $0 TYPE PRIVATEKEY HOST";
    exit -1;
  else
    HOST=${DEFAULT_HOST}
  fi
fi

if [ ! -f nodes/${HOST}.json ];then
  echo "copying typical ${TYPE}-type json for ${HOST} ... ";
  cp -p nodes/${TYPE}_default.json nodes/${HOST}.json
fi

echo "preparing ${HOST} ... "
knife solo prepare -i ${PRIVATEKEY} --ssh-config-file ssh_config ec2-user@${HOST}
