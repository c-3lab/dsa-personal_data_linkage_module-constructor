#!/bin/bash

mkdir cert; cd cert
openssl genrsa -out client.key 4096
openssl req -x509 -days 36500 -newkey rsa:2048 -nodes -out client-ca.crt -keyout client.key -subj "/C=JP/ST=Tokyo/L=Shinkuku-ku/O=Client Co./OU=tech dept./CN=client.example.com/"
openssl req -x509 -days 36500 -newkey rsa:2048 -nodes -out server.crt -keyout server.key -subj "/C=JP/ST=Tokyo/L=Shinkuku-ku/O=Server Co./OU=tech dept./CN=server.example.com/"

