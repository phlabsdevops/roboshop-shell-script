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

dnf install nginx -y &>> $LOG_FILE

VALLIDATE $? "Installing nginx"

systemctl enable nginx &>> $LOG_FILE

VALLIDATE $? "Enabling nginx"

systemctl start nginx &>> $LOG_FILE

VALLIDATE $? "Start nginx"

rm -rf /usr/share/nginx/html/* &>> $LOG_FILE

VALLIDATE $? "Remove default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOG_FILE

VALLIDATE $? "Downloading web application"

cd /usr/share/nginx/html &>> $LOG_FILE

VALLIDATE $? "Moving to nginx html directory"

unzip -o /tmp/web.zip &>> $LOG_FILE

VALLIDATE $? "unzipping web"

cp /home/centos/roboshop-shell-script/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>> $LOG_FILE

VALLIDATE $? "Copied roboshop reverse proxy config"

systemctl restart nginx &>> $LOG_FILE

VALLIDATE $? "Restart nginx"







