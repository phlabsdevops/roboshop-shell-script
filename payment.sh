#!/bin/bash
#  this is for comment
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[34m"
N="\e[0m"

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

dnf install python36 gcc python3-devel -y &>> $LOG_FILE 

id roboshop 
if [ $? -ne 0 ]
then
useradd roboshop 
VALLIDATE $? "Creating Roboshop User"   
else 
echo -e "roboshop user already exists...$Y skipping $N"
fi

mkdir -p /app 

VALLIDATE $? "Creating App directory"   

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOG_FILE

VALLIDATE $? "Downloading payment"   

cd /app 

VALLIDATE $? "Changing app directory"   

unzip -o /tmp/payment.zip &>> $LOG_FILE

VALLIDATE $? "Unzipping payment"   

pip3.6 install -r requirements.txt &>> $LOG_FILE

VALLIDATE $? "Installing Dependencies"   

cp /home/centos/roboshop-shell-script/payment.service /etc/systemd/system/payment.service &>> $LOG_FILE

VALLIDATE $? "Copying payment.service"   

systemctl daemon-reload &>> $LOG_FILE

VALLIDATE $? "Daemon reload"   

systemctl enable payment &>> $LOG_FILE 

VALLIDATE $? "Enable payment"   

systemctl start payment &>> $LOG_FILE

VALLIDATE $? "Start payment"   
