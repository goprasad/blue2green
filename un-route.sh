#!/bin/bash

set +e

pwd

cf api $CF_LOGIN_URL --skip-ssl-validation

cf login -u $CF_USER -p $CF_PASSWORD -o "$CF_ORGANIZATION" -s "$CF_SPACE"


cf apps | grep "$APP_NAME" | grep start
if [ $? -eq 0 ]
then
  echo "Renaming app"
  cf rename $APP_NAME $APP_NAME-bkp
  cf stop $APP_NAME-bkp
fi

cf rename $APP_NAME-X $APP_NAME
cf unmap-route $APP_NAME $CF_DOMAIN_NAME --hostname $APP_NAME$CF_PROFILE-X
cf unmap-route $APP_NAME-Y $CF_DOMAIN_NAME --hostname $APP_NAME$CF_PROFILE-Y

cf apps | grep "$APP_NAME-Y-bkp" | grep stop
if [ $? -eq 0 ]
then
  echo "Deleteting app Y bkp"
  cf unmap-route $APP_NAME-Y-bkp $CF_DOMAIN_NAME --hostname $APP_NAME$CF_PROFILE-Y
fi

set -e

echo "Routes updated"

cf routes