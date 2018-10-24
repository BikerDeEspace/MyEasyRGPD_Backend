#!/usr/bin/env bash

# INIT .ENV FILE
if [ -f .env ]
then
    source .env
else
    echo "Please run this script from project root, and check .env file as it is mandatory"
    echo "If it is missing a quick solution is :"
    echo "ln -s .env.dist .env"
    exit 42
fi

echo '** BEGIN POST INSTALL SCRIPT **'

# INIT DB SCRIPT
## CREATE DATABASE
echo '** DATABASE MIGRATION **'
bin/console doctrine:migrations:migrate --no-interaction

## START SERVER
#bin/console server:start

export PGPASSWORD=${DBPASSWORD}
## CREATE DEFAULT USER
userexist=$(psql -qt --no-align -w -h ${DBHOST} -c "select count(*) from pia_user where email='lici@lusis.lu';" -U ${DBUSER} -d ${DBNAME}  )
if [ $userexist -eq 0 ] && [ ${CREATE_USER} == "TRUE" ]; then
    echo '** CREATE DEFAULT SUPER USER **'
    bin/console pia:user:create ${USER_MAIL} ${USER_PASSWORD} 
    bin/console pia:user:promote ${USER_MAIL} --role=ROLE_SUPER_ADMIN
fi

## CREATE DEFAULT APP
appexist=$(psql -qt --no-align -w -h ${DBHOST} -c "select count(*) from oauth_client where name='Default App';" -U ${DBUSER} -d ${DBNAME}  )
if [ $appexist -eq 0 ] && [ ${CREATE_APP} == "TRUE" ]; then
    echo '** CREATE DEFAULT APP **'
    bin/console pia:application:create --name="${CLIENT_NAME}" --url="${CLIENTURL}" --client-id=${CLIENT_ID} --client-secret=${CLIENT_SECRET}
fi

echo '** END POST INSTALL SCRIPT **'