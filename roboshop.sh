#!/bin/bash
AMI="ami-0f3c7d07486cad139"
SG_ID="sg-0c0883cad63eb869b" #replace with your SG id
INSTANCES=("mongodb" "redis" "mysql" "user" "cart" "payment" "shipping" "dispatch" "rabbitmq" "catalogue" "web")
ZONE_ID=Z04924361LJBMTTD4CTY6
DOMAIN_NAME="phlabsdevops.online"
for i in "${INSTANCES[@]}"
do
echo "Instance is: $i"
if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ] 
then
INSTANCE_TYPE="t3.small"
else
INSTANCE_TYPE="t2.micro"
fi
IP_ADDRESS=$(aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --count 1 --instance-type $INSTANCE_TYPE --security-group-ids sg-0c0883cad63eb869b --tag-specifications "ResourceType=instance,
Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
echo "$i:$IP_ADDRESS"

aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '
{
    "Comment": "Creating a record set for cognito endpoint"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$i'.'$DOMAIN_NAME'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP_ADDRESS'"
        }]
      }
    }]
  }
  '

done

