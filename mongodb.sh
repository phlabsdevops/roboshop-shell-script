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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE

VALLIDATE $? "Copy MongoDB Repo"

dnf install mongodb-org -y &>> $LOG_FILE

VALLIDATE $? "Installing  MongoDB" 

systemctl enable mongod &>> $LOG_FILE

VALLIDATE $? "Enabling  MongoDB" 

systemctl start mongod &>> $LOG_FILE

VALLIDATE $? "Starting  MongoDB"

sed  -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOG_FILE

VALLIDATE $? "Remote Access to mongodb"

systemctl restart mongod &>> $LOG_FILE

VALLIDATE $? "Restart mongodb"