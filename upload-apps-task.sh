#!/bin/bash

set +e
cd repo;
pwd

cf api $CF_LOGIN_URL --skip-ssl-validation

cf login -u $CF_USER -p $CF_PASSWORD -o "$CF_ORGANIZATION" -s "$CF_SPACE"

cf push $APP_NAME-X -f manifest.yml  --hostname $APP_NAME$CF_PROFILE-X
#cf unmap-route $APP_NAME-X $CF_DOMAIN_NAME --hostname $APP_NAME$CF_PROFILE


cf apps | grep "$APP_NAME-Y-bkp" | grep stop
if [ $? -eq 0 ]
then
  echo "Deleteting app Y -bkp"
  cf delete $APP_NAME-Y-bkp -f
fi

cf apps | grep "$APP_NAME-Y" | grep stop
if [ $? -eq 0 ]
then
  echo "Re-naming app Y to -bkp"
  cf rename $APP_NAME-Y $APP_NAME-Y-bkp
fi

cf push $APP_NAME-Y -f manifest.yml  --hostname $APP_NAME$CF_PROFILE-Y --no-start
#cf unmap-route $APP_NAME-Y $CF_DOMAIN_NAME --hostname $APP_NAME$CF_PROFILE

set -e
