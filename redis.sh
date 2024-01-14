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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOG_FILE 

VALLIDATE $? "Installing Remi Release"

dnf module enable redis:remi-6.2 -y &>> $LOG_FILE 

VALLIDATE $? "Enabling Redis"  

dnf install redis -y &>> $LOG_FILE 

VALLIDATE $? "Installing Redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOG_FILE 

VALLIDATE $? "Remote access to Redis"

systemctl enable redis &>> $LOG_FILE   

VALLIDATE $? "Enable redis"

systemctl start redis &>> $LOG_FILE

VALLIDATE $? "Start redis"

