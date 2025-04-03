#!/bin/bash
# =========================================================================
# STUDENT MANAGEMENT SYSTEM - MAIN APPLICATION
# =========================================================================
# Authors: Muhammad Fahad(23F-0696) & Ajmal Razaq(23F-0524)
# Date: April 2025
#
# DESCRIPTION:
# -----------
# This is the main entry point for the Student Management System.
# It provides authentication for teachers and students, and serves as
# the controller for the application workflow.
#
# MENU STRUCTURE:
# -------------
# 1. Teacher Portal - For managing students, marks and academic records
# 2. Student Portal - For students to view their grades and CGPA
# 3. Credits - Display application authors
# 0. Exit - Exit the system
#
# AUTHENTICATION:
# -------------
# Teacher: Single administrator account with fixed credentials
# Students: Individual accounts with IDs and passwords stored in AUTH_FILE
#
# COMPONENT SCRIPTS:
# ----------------
# teacher.sh: Contains all teacher management functions
# student.sh: Contains all student view functions
#
# FILE STRUCTURE:
# --------------
# $S_FILE: Stores student personal information
#         Format: student_id,name,age,department
# $AUTH_FILE: Stores student authentication credentials
#         Format: student_id,password
# $M_FILE: Stores student marks, grades and CGPA
#         Format: student_id,OS_marks,DB_marks,PROB_marks,OS_grade,DB_grade,PROB_grade,CGPA
#-----------------------
# FUNCTIONS IN THIS FILE:
# ---------------------
# main_menu(): Displays the main application menu
# credits(): Shows application credits and author information
# auth_animation(): Displays login progress animation
# unauth_animation(): Displays logout progress animation
# authenticate_t(): Handles teacher authentication
# authenticate_s(): Handles student authentication
# main(): Main program loop (implicit in the script)




# Import the other script files ################################################
source ./teacher.sh
source ./student.sh
################################################################################




# color codes #################################################################
CYAN='\033[1;36m'
BLUE='\033[1;34m'
RESET='\033[0m'
BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
BOLD_YELLOW='\033[1;33m'
###############################################################################



# file paths #################################################################
S_FILE="students.txt"
M_FILE="marks.txt"
AUTH_FILE="auth.txt"
##############################################################################








# Function to display the welcome menu ###################################
main_menu()
{
    clear
    echo -e "${BOLD_YELLOW}Welcome to Student Management System${RESET}"
    echo -e "[01] Teacher Portal"
    echo -e "[02] Student Portal"
    echo -e "[03] Credits"
    echo -e "[00] Exit System"
}
#############################################################################




#Credits function ###########################################################
credits()
{
    clear
    echo -e "${BOLD_YELLOW}Developed By: Muhammad Fahad(23F-0696) & Ajmal Razaq(23F-0524)${RESET}"
    echo -e "Press Enter To Return To Main Menu..."
    read -r
    return
}
################################################################################






# function to dispaly login animation ##########################################
auth_animation() 
{
    clear
    echo -ne "${BOLD_GREEN}\nLogging In: "
    for ((i=0; i<20; i++)); do
        sleep 0.05
        echo -ne "▓"
    done
    echo -ne "${RESET}"
    echo -ne "\n"
    sleep 1
    clear
}
################################################################################





#function to show logout animation ############################################
unauth_animation() 
{
    clear
    echo -ne "${BOLD_RED}\nLogging Out: "
    for ((i=0; i<20; i++)); do
        sleep 0.05
        echo -ne "▓"
    done
    echo -ne "${RESET}"
    echo -ne "\n"
    sleep 1
    clear
}
################################################################################







#Teacher credentials  ##########################################################
teacher_uname="admin"
teacher_pass="123"
teacher_name="Admin"
################################################################################








#Authentication function for teacher ###########################################
authenticate_t()
{
    clear
    local input_uname input_pass
    while true; do
        echo -e "${CYAN}Enter Your Log In Details${RESET}"
        read -p "Teacher Username: " input_uname
        
        # Empty username validation
        while [[ -z "$input_uname" ]]; do
            echo -e "${BOLD_RED}Username Cannot Be Empty!${RESET}"
            read -p "Teacher Username: " input_uname
        done
        
        read -p "Password: " input_pass
        
        # Empty password validation
        while [[ -z "$input_pass" ]]; do
            echo -e "${BOLD_RED}Password Cannot Be Empty!${RESET}"
            read -p "Password: " input_pass
        done
        
        auth_animation
        echo
        if [[ "$input_uname" == "$teacher_uname" && "$input_pass" == "$teacher_pass" ]]; then
            return 0
        else
            echo -e "${BOLD_RED}Invalid Credentials Try again!!${RESET}"
        fi
    done
}

################################################################################










#Authentication function for student ###########################################
authenticate_s()
{
    clear
    local input_id input_password found
    while true; do
        echo -e "\n${CYAN}Enter Your Log In Details${RESET}"
        read -p "Student ID: " input_id
        
        # Empty ID validation
        while [[ -z "$input_id" ]]; do
            echo -e "${BOLD_RED}Student ID Cannot Be Empty!${RESET}"
            read -p "Student ID: " input_id
        done
        
        read -p "Password: " input_password
        
        # Empty password validation
        while [[ -z "$input_password" ]]; do
            echo -e "${BOLD_RED}Password Cannot Be Empty!${RESET}"
            read -p "Password: " input_password
        done
        
        auth_animation
        echo
        stored_password=$(grep "^$input_id," "$AUTH_FILE" | head -1 | cut -d',' -f2)
        if [[ "$stored_password" == "$input_password" ]]; then
            student_current_id="$input_id"
            student_name=$(grep "^$input_id," "$S_FILE" | cut -d',' -f2)
            return 0
        else
            echo -e "${BOLD_RED}Invalid Credentials Try Again!!${RESET}"
        fi
    done
    return 1
}

################################################################################










# Main program loop ############################################################
main_choice=1
while [[ $main_choice -ne 0 ]]; do
    main_menu
    echo -e "${BOLD_YELLOW}"
    read -p 'Enter Your Choice: ' main_choice
    
    # Empty choice validation
    while [[ -z "$main_choice" ]]; do
        echo -e "${BOLD_RED}Choice Cannot Be Empty!${RESET}"
        read -p 'Enter Your Choice: ' main_choice
    done
    
    echo -e "${RESET}"
      
     # Teacher Portal
    if [[ $main_choice -eq 1 ]]; then
        authenticate_t
        teacher_choice=1
        while [[ $teacher_choice -ne 0 ]]; do
            teacher_ka_menu
            echo
            echo -e "${BOLD_YELLOW}"
            read -p 'Enter Your Choice: ' teacher_choice
            
            # Empty choice validation
            while [[ -z "$teacher_choice" ]]; do
                echo -e "${BOLD_RED}Choice Cannot Be Empty!${RESET}"
                read -p 'Enter Your Choice: ' teacher_choice
            done
            
            echo -e "${RESET}"
            if [[ $teacher_choice -eq 1 ]]; then
                add_student
            elif [[ $teacher_choice -eq 2 ]]; then
                del_student
            elif [[ $teacher_choice -eq 3 ]]; then
                assign_marks
            elif [[ $teacher_choice -eq 4 ]]; then
                calculate_grades
            elif [[ $teacher_choice -eq 5 ]]; then
                calculate_cgpa
            elif [[ $teacher_choice -eq 6 ]]; then
                passed_students
            elif [[ $teacher_choice -eq 7 ]]; then
                failed_students
            elif [[ $teacher_choice -eq 8 ]]; then
                list_students_asc_cgpa
            elif [[ $teacher_choice -eq 9 ]]; then
                list_students_desc_cgpa
            elif [[ $teacher_choice -eq 0 ]]; then
                 unauth_animation
            else
                echo -e "${BOLD_YELLOW}Invalid Choice!${RESET}"
            fi
        done



    #Student Portal
    elif [[ $main_choice -eq 2 ]]; then
        
        if authenticate_s; then
            student_choice=1
            while [[ $student_choice -ne 0 ]]; do
                student_ka_menu 
                echo -e "${BOLD_YELLOW}"
                read -p 'Enter Your Choice: ' student_choice
                
                # Empty choice validation
                while [[ -z "$student_choice" ]]; do
                    echo -e "${BOLD_RED}Choice Cannot Be Empty!${RESET}"
                    read -p 'Enter Your Choice: ' student_choice
                done
                
                echo -e "${RESET}"
                if [[ $student_choice -eq 1 ]]; then
                    view_student_grades
                elif [[ $student_choice -eq 2 ]]; then
                    view_student_cgpa
                elif [[ $student_choice -eq 0 ]]; then
                    unauth_animation
                else
                    echo -e "${BOLD_YELLOW}Invalid Choice!${RESET}"
                fi
            done
        fi
    elif [[ $main_choice -eq 3 ]]; then
        credits
    elif [[ $main_choice -eq 0 ]]; then
        echo -e "${BOLD_YELLOW}Goodbye!${RESET}"
    else
        echo -e "${BOLD_YELLOW}Invalid Choice!${RESET}"
    fi
done
################################################################################