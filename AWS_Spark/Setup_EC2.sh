#!/bin/bash
# Create and launch an AWS EC2 Instance

echo $1
f='.pem'
file=$1$f
start='-----BEGIN RSA PRIVATE KEY-----'
end='-----END RSA PRIVATE KEY-----'
key=$(aws ec2 create-key-pair --key-name $1 | awk '/-----BEGIN RSA PRIVATE KEY-----/{y=1;next}y')
echo $key | sed 's/-.*//' > temp.pem
tr ' ' '\n' < temp.pem > temp2.pem
echo '-----BEGIN RSA PRIVATE KEY-----' | cat - temp2.pem > temp && mv temp temp2.pem
sed '$d' temp2.pem > $file
echo '-----END RSA PRIVATE KEY-----' >> $file
chmod 400 $file
group=$(aws ec2 create-security-group --group-name AWS-SecGroup --description "Machine IP")
ip=$(wget http://ipinfo.io/ip -qO -)
ip=$ip$"/32"
echo $ip
aws ec2 authorize-security-group-ingress --group-name AWS-SecGroup --protocol tcp --port 22 --cidr $ip
aws ec2 run-instances --image-id ami-f0091d91 --instance-type t2.small --key $1 --security-group-ids $group
echo $"Your instance has been set up and is now booting up."
echo 
secs=$((5 * 60))
while [ $secs -gt 0 ]; do
   echo -ne $"The machine will be ready in: "$"$secs\033[0K\r"
   sleep 1
   : $((secs--))
done
echo
aws ec2 describe-instances --output table | grep -o "PublicDnsName.*" | sed -n '/ec2-/,/.com/p' | awk -v FS="(ec2-|.com)" '{print $2}' > dns.txt
dns=$(head -1 dns.txt)
dns=$"ec2-user@ec2-"$dns$".compute.amazonaws.com"
echo $"ssh -i \""$file$"\" "$dns >> Login.sh