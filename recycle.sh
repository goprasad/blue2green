#!/bin/bash

set +e

pwd

cf api $CF_LOGIN_URL --skip-ssl-validation

cf login -u $CF_USER -p $CF_PASSWORD -o "$CF_ORGANIZATION" -s "$CF_SPACE"

echo "start -Y app and stop -X app"
cf start $APP_NAME-Y
cf stop $APP_NAME

echo "start -X app and stop -Y app"
cf start $APP_NAME
cf stop $APP_NAME-Y

set -e

echo "Routes updated"

cf routes