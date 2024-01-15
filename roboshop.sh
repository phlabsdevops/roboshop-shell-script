#!/bin/bash
AMI="ami-03265a0778a880afb"
SG_ID="sg-0c0883cad63eb869b" #replace with your SG id
INSTANCES=("mongodb" "redis" "mysql" "user" "cart" "payment" "shipping" "dispatch" "rabbitmq" "catalogue" "web")

for i in "${INSTANCES[@]}"
do
echo "Instance is: $i"
if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ] 
then
INSTANCE_TYPE="t3.small"
else
INSTANCE_TYPE="t2.micro"
aws ec2 run-instances --image-id ami-03265a0778a880afb --count 1 --instance-type $INSTANCE_TYPE --security-group-ids sg-0c0883cad63eb869b
done

