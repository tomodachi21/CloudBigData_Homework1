#!/bin/bash
# Login to my AWS Instance

ip=$(wget http://ipinfo.io/ip -qO -)
ip=$ip$"/32"
echo $"You are loggin in from IP: "$ip
aws ec2 authorize-security-group-ingress --group-name AWS-SecGroup --protocol tcp --port 22 --cidr $ip &> /dev/null &
echo
ssh -i "efj2106-Test.pem" ubuntu@ec2-52-35-80-198.us-west-2.compute.amazonaws.com
