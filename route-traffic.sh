#!/bin/bash

set +e

pwd

cf api $CF_LOGIN_URL --skip-ssl-validation

cf login -u $CF_USER -p $CF_PASSWORD -o "$CF_ORGANIZATION" -s "$CF_SPACE"

cf routes

cf map-route $APP_NAME-X $CF_DOMAIN_NAME --hostname $APP_NAME$CF_PROFILE
cf map-route $APP_NAME-Y $CF_DOMAIN_NAME --hostname $APP_NAME$CF_PROFILE

cf apps | grep "$APP_NAME-bkp" | grep stop
if [ $? -eq 0 ]
then
  echo "Deleteting Route for -bkp"
  cf delete $APP_NAME-bkp -f
fi

set -e

echo "Routes updated"

cf routes