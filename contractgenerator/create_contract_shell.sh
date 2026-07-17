#!/bin/bash

# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0

#terraform init
#terraform destroy -auto-approve

. ./terraform.tfvars

HPVSNAME=signer4mpc

rm -rf ./docker-compose/*
#terraform apply -auto-approve

sed -e "s#IMAGE#${REGISTRY_URL}/${IMAGE}#" docker-compose.yaml.template > docker-compose/docker-compose.yaml


sed -e 's/<<-EOT/$(cat <<-EOT /' -e 's/^EOT/EOT\n)/' ./terraform.tfvars > ./o.$$ 
for i in IMAGE SYSLOG REGISTRY MACHINE1 HSMDOMAIN1 SECRET_B24 MKVP HPCR_CERT DATA_ENV_PASS DATA_WORKLOAD_PASS BITGO
do
  sed -i "s/^$i/export $i/" ./o.$$
done

. ./o.$$
rm ./o.$$


export COMPOSE=`tar -cz -C docker-compose/ . | base64 -w0`
WORKLOAD=`pwd`/$HPVSNAME.workload.yml
envsubst < workload.tpl > $WORKLOAD

ENV=`pwd`/$HPVSNAME.env.yml
envsubst < env.tpl > $ENV
sed -i '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/ s/^/      /' $ENV
sed -i '/-----BEGIN PRIVATE KEY-----/,/-----END PRIVATE KEY-----/ s/^/      /' $ENV

CONTRACT_KEY=.ibm-hyper-protect-container-runtime-encrypt.crt

envsubst < hpcr_contractkey.tpl > $CONTRACT_KEY

PASSWORD=`openssl rand -base64 32`
ENCRYPTED_PASSWORD="$(echo -n "$PASSWORD" | base64 -d | openssl rsautl -encrypt -inkey $CONTRACT_KEY -certin | base64 -w0 )"
ENCRYPTED_WORKLOAD="$(echo -n "$PASSWORD" | base64 -d | openssl enc -aes-256-cbc -pbkdf2 -pass stdin -in "$WORKLOAD" | base64 -w0)"
echo "workload: hyper-protect-basic.${ENCRYPTED_PASSWORD}.${ENCRYPTED_WORKLOAD}" > $HPVSNAME.yml

PASSWORD=`openssl rand -base64 32`
ENCRYPTED_PASSWORD="$(echo -n "$PASSWORD" | base64 -d | openssl rsautl -encrypt -inkey $CONTRACT_KEY -certin | base64 -w0 )"
ENCRYPTED_ENV="$(echo -n "$PASSWORD" | base64 -d | openssl enc -aes-256-cbc -pbkdf2 -pass stdin -in "$ENV" | base64 -w0)"
echo "env: hyper-protect-basic.${ENCRYPTED_PASSWORD}.${ENCRYPTED_ENV}" >> $HPVSNAME.yml
 
rm $CONTRACT_KEY

cp $HPVSNAME.yml install/user-data

