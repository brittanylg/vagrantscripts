#!/bin/bash

openssl req -new -x509 -days 365 -nodes \
    -out /etc/ssl/certs/ssl.crt \
    -keyout /etc/ssl/private/ssl.key \
    -subj "/C=RO/ST=Bucharest/L=Bucharest/O=IT/CN=www.example.ro"


sudo service apache2 restart