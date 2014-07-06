#!/bin/bash

PRIVATEKEY=$1
HOST=$2

if [ "${PRIVATEKEY}" = "" ]; then
  if [ "${DEFAULT_PRIVATEKEY}" = "" ]; then
    echo "usage: $0 PRIVATEKEY HOST";
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
    echo "usage: $0 PRIVATEKEY HOST";
    exit -1;
  else
    HOST=${DEFAULT_HOST}
  fi
fi

ssh -i ${PRIVATEKEY} -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" ec2-user@${HOST}
