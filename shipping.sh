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

dnf install maven -y

id roboshop 
if [ $? -ne 0 ]
then
useradd roboshop 
VALLIDATE $? "Creating Roboshop User"   
else 
echo -e "roboshop user already exists...$Y skipping $N"
fi

mkdir -p /app

VALLIDATE $? "Creating app directory"   

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOG_FILE

VALLIDATE $? "Installing Shipping"   

cd /app

VALLIDATE $? "Moving to app directory"   

unzip -o /tmp/shipping.zip &>> $LOG_FILE

VALLIDATE $? "Unzipping shipping"   
   
mvn clean package &>> $LOG_FILE

VALLIDATE $? "Installing Dependencies"   

mv target/shipping-1.0.jar shipping.jar &>> $LOG_FILE

VALLIDATE $? "Renaming Jar File"   

cp /home/centos/roboshop-shell-script/shipping.service /etc/systemd/system/shipping.service &>> $LOG_FILE

VALLIDATE $? "Copying Shipping service"   

systemctl daemon-reload &>> $LOG_FILE

VALLIDATE $? "Daemon Reload"   

systemctl enable shipping  &>> $LOG_FILE

VALLIDATE $? "Enabling shipping"   

systemctl start shipping &>> $LOG_FILE

VALLIDATE $? "Start shipping"   

dnf install mysql -y &>> $LOG_FILE

VALLIDATE $? "Install mysql client"   

mysql -h mysql.phlabsdevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOG_FILE 

VALLIDATE $? "Loading shipping data"   

systemctl restart shipping &>> $LOG_FILE

VALLIDATE $? "Restarting shipping"   



