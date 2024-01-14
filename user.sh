#!/bin/bash
#  this is for comment

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[34m"
N="\e[0m"

MONGODB_HOST=mongodb.phlabsdevops.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started executing at $TIMESTAMP" &>> $LOG_FILE 

VALLIDATE(){
    if [ $1 -ne 0 ]
    then       
    echo -e "$R ERROR:$N $2 $R FAILED $N"
    exit 1
    else
    echo -e "$G $2 SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
echo -e "$R Please run the script with root user $N"
exit 1
else
echo -e "$G You are root user $N"
fi

dnf module disable nodejs -y &>> $LOG_FILE

VALLIDATE $? "Disable current NodeJS"  

dnf module enable nodejs:18 -y &>> $LOG_FILE

VALLIDATE $? "Enable NodeJS:18"  

dnf install nodejs -y &>> $LOG_FILE

VALLIDATE $? "Installing NodeJS:18"  

id roboshop 
if [ $? -ne 0 ]
then
useradd roboshop 
VALLIDATE $? "Creating Roboshop User"   
else 
echo -e "roboshop user already exists...$Y skipping $N"
fi

mkdir -p /app &>> $LOG_FILE

VALLIDATE $? "Creating App Directory" 

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

VALLIDATE $? "Downloading user application"

cd /app 

unzip -o /tmp/user.zip &>> $LOG_FILE

VALLIDATE $? "Unzipping User appilcation"

cd /app 

npm install &>> $LOG_FILE

VALLIDATE $? "Installing Dependencies" 

cp /home/centos/roboshop-shell-script/user.service /etc/systemd/system/user.service &>> $LOG_FILE

VALLIDATE $? "Copying user.service file" 

systemctl daemon-reload &>> $LOG_FILE

VALLIDATE $? "user daemon reload"

systemctl enable user &>> $LOG_FILE

VALLIDATE $? "Enable user"

systemctl start user &>> $LOG_FILE

VALLIDATE $? "Start user"

cp /home/centos/roboshop-shell-script/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE

VALLIDATE $? "Copying mongo repo"

dnf install mongodb-org-shell -y &>> $LOG_FILE

VALLIDATE $? "Installing mongodb client"

mongo --host $MONGODB_HOST </app/schema/user.js &>> $LOG_FILE

VALLIDATE $? "Loading user data into MongoDB"



