#!/bin/bash

# https://stackoverflow.com/questions/57784287/how-to-install-nginx-on-aws-ec2-linux-2

# Install Nginx
sudo amazon-linux-extras install -y nginx1
sudo systemctl enable nginx
sudo systemctl start nginx