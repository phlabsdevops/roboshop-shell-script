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

dnf module disable mysql -y &>> $LOG_FILE

VALLIDATE $? "Disable current version"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOG_FILE

VALLIDATE $? "Copied MySql repo"

dnf install mysql-community-server -y

VALLIDATE $? "Installing mysql server"

systemctl enable mysqld

VALLIDATE $? "Enable mysql"

systemctl start mysqld

VALLIDATE $? "Start mysql"

mysql_secure_installation --set-root-pass RoboShop@1

VALLIDATE $? "Setting MySql root Password"

mysql -uroot -pRoboShop@1

