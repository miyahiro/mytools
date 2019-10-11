#!/bin/bash
TARGET_HOSTS="host1 host2 host3"
TARGET_USER=wsuser

ACCESS_USER=root
ACCESS_KEY_FILE=/root/.ssh/id_rsa

KEY_STORE=/root
KEY_FILE_PRIVATE=id_rsa_${TARGET_USER}_`date "+%Y%m%d_%H%M%S"`
KEY_FILE_PUBLIC=${KEY_FILE_PRIVATE}.pub
KEY_FILE_PRIVATE_FULL=${KEY_STORE}/${KEY_FILE_PRIVATE}
KEY_FILE_PUBLIC_FULL=${KEY_STORE}/${KEY_FILE_PUBLIC}


ssh-keygen -t rsa -N "" -f ${KEY_FILE_PRIVATE_FULL}

for host in ${TARGET_HOSTS};do
  scp -i ${ACCESS_KEY_FILE} ${KEY_FILE_PUBLIC_FULL} ${ACCESS_USER}@${host}:~/.ssh
  ssh -i ${ACCESS_KEY_FILE} -l ${ACCESS_USER} "cat ~/.ssh/${KEY_FILE_PUBLIC} > ~/.ssh/authorized_keys"
  ssh -i ${ACCESS_KEY_FILE} -l ${ACCESS_USER} "chown ${TARGET_USER}:${TARGET_USER} ~/.ssh/authorized_keys"
  ssh -i ${ACCESS_KEY_FILE} -l ${ACCESS_USER} "chmod 600 ~/.ssh/authorized_keys"
done
