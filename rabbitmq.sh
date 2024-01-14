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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOG_FILE 

VALLIDATE $? "Downloading erlang script"   

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOG_FILE 

VALLIDATE $? "Downloading rebbitmq script"   

dnf install rabbitmq-server -y &>> $LOG_FILE  

VALLIDATE $? "installing rabbitmq-server"   

systemctl enable rabbitmq-server &>> $LOG_FILE  

VALLIDATE $? "Enabling rabbitmq-server"   

systemctl start rabbitmq-server &>> $LOG_FILE  

VALLIDATE $? "Starting rabbitmq-server"   

rabbitmqctl add_user roboshop roboshop123 &>> $LOG_FILE 

VALLIDATE $? "Creating user"   

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG_FILE 

VALLIDATE $? "Setting permissions"   
