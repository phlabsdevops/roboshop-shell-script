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

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOG_FILE

VALLIDATE $? "Downloading cart appilcation" 

cd /app &>> $LOG_FILE

unzip -o /tmp/cart.zip &>> $LOG_FILE

VALLIDATE $? "Unzipping cart appilcation"

npm install &>> $LOG_FILE

VALLIDATE $? "Installing Dependencies" 

#use absolute path, because cart.service exist there
cp /home/centos/roboshop-shell-script/cart.service /etc/systemd/system/cart.service &>> $LOG_FILE

VALLIDATE $? "Copying cart.service file" 

systemctl daemon-reload &>> $LOG_FILE

VALLIDATE $? "cart daemon reload"

systemctl enable cart &>> $LOG_FILE

VALLIDATE $? "Enable cart"

systemctl start cart &>> $LOG_FILE

VALLIDATE $? "Start cart"

