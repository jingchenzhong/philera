#!/bin/bash

ssh-keygen -t rsa && chmod 600 ~/.ssh/id_rsa.pub && cat ~/.ssh/id_rsa.pub | 
ssh $1@$2 "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys; chmod 600 ~/.ssh/id_rsa.pub"
