#!/bin/bash

wget -q -O cf-cli.deb https://cli.run.pivotal.io/stable?release=debian64
sudo dpkg -i cf-cli.deb
cf login -u $CF_USERNAME -p $CF_PASSWORD -o $CF_ORG -s $CF_SPACE -a $CF_API_ENDPOINT

cd whiteboard

cf set-env whiteboard OKTA_SSO_TARGET_URL $OKTA_SSO_TARGET_URL
cf set-env whiteboard OKTA_CERT_FINGERPRINT $OKTA_CERT_FINGERPRINT
cf set-env whiteboard IP_WHITELIST $IP_WHITELIST
cf set-env whiteboard SENTRY_DSN $SENTRY_DSN
cf set-env whiteboard WHITEBOARD_MAILER_URL $WHITEBOARD_MAILER_URL

if [ "$ENVIRONMENT" == "production" ] ; then
    cf set-env whiteboard EXCEPTIONAL_API_KEY $EXCEPTIONAL_API_KEY
    cf set-env whiteboard GOOGLE_CLIENT_ID $GOOGLE_CLIENT_ID
    cf set-env whiteboard GOOGLE_CLIENT_SECRET $GOOGLE_CLIENT_SECRET
    cf set-env whiteboard NEWRELIC_APP_NAME $NEWRELIC_APP_NAME
    cf set-env whiteboard NEWRELIC_LICENSE $NEWRELIC_LICENSE

elif [ "$ENVIRONMENT" == "cso-production" ]; then
    cf set-env whiteboard EXCEPTIONAL_API_KEY $EXCEPTIONAL_API_KEY
fi

bundle install

#takes hostname from config/cf-{ENVIRONMENT}.yml manifest
bundle exec rake SPACE=$CF_SPACE cf:deploy:$ENVIRONMENT
