#!/bin/bash
echo "Student Management System"
echo "Choose an option"
echo "1. Login as Teacher"
echo "2. Login as Student"
echo "3. Exit"
read option
case $option in
1) echo "Enter your username"
read username
echo "Enter your password"
read password
if [ $username == "teacher" ] && [ $password == "teacher" ]
then
echo "Login Successful"
./teacher.sh
else
echo "Login Failed"
fi
;;
2) echo "Enter your username"
read username
echo "Enter your password"
read password
if [ $username == "student" ] && [ $password == "student" ]
then
echo "Login Successful"
./student.sh
else
echo "Login Failed"
fi
;;
3) echo "Exiting"
exit
;;
*) echo "Invalid option"
;;
esac
