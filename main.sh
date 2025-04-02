#!/bin/bash
# Import the other script files
source ./teacher.sh
source ./student.sh

# color codes
CYAN='\033[1;36m'
BLUE='\033[1;34m'
RESET='\033[0m'
BOLD_CYAN='\033[1;36m' 
BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
BOLD_YELLOW='\033[1;33m'

# file paths
S_FILE="students.txt"
M_FILE="marks.txt"
AUTH_FILE="auth.txt"

# unction to display the welcome menu
main_menu()
{
    clear
    echo -e "${BOLD_YELLOW}Welcome to Student Management System${RESET}"
    echo -e "Developed By: Mian Fahad & Ajmal Razaq\n"
    echo -e "1. Teacher Portal"
    echo -e "2. Student Portal"
    echo -e "0. EXIT"
    echo -e  "${RESET}"
}


# function to dispaly authentication animation
auth_animation() 
{
    clear
    echo -ne "${BOLD_GREEN}\nLogging in: "
    for ((i=0; i<20; i++)); do
        sleep 0.05
        echo -ne "▓"
    done
    echo -ne "${RESET}"
    echo -ne "\n"
    sleep 1
    clear
}


#function to show logout animation
unauth_animation() 
{
    clear
    echo -ne "${BOLD_RED}\nLogging out: "
    for ((i=0; i<20; i++)); do
        sleep 0.05
        echo -ne "▓"
    done
    echo -ne "${RESET}"
    echo -ne "\n"
    sleep 1
    clear
}



#Teacher credentials
teacher_uname="mian"
teacher_pass="123"
teacher_name="Mian Fahad"



#Authentication function for teacher
authenticate_t()
{
    clear
    local input_uname input_pass
    while true; do
        echo -e "${CYAN}Enter Your Log In Details${RESET}"
        read -p "Username: " input_uname
        read -p "Password: " input_pass
        auth_animation
        echo
        if [[ "$input_uname" == "$teacher_uname" && "$input_pass" == "$teacher_pass" ]]; then
        return 0
        else
        echo -e "${BOLD_RED}Invalid credentials Try again!!${RESET}"
        fi
    done
}



#Authentication function for student
authenticate_s()
{
    clear
    local input_id input_password found
    echo -e "\n${CYAN}Enter Your Log In Details${RESET}"
    read -p "Student ID: " input_id
    read -p "Password: " input_password
    auth_animation
    echo
    
    # Check if student exists in auth file
    if grep -q "^$input_id," "$AUTH_FILE" 2>/dev/null; then
        stored_password=$(grep "^$input_id," "$AUTH_FILE" | head -1 | cut -d',' -f2)
        
        if [[ "$stored_password" == "$input_password" ]]; then
            student_current_id="$input_id"
            student_name=$(grep "^$input_id," "$S_FILE" | cut -d',' -f2)
            return 0
        fi
    fi
    echo -e "${BOLD_YELLOW}Invalid credentials try again!!${RESET}"
    sleep 2
    return 1
}



main_choice=1
while [[ $main_choice -ne 0 ]]; do
    main_menu
    echo -e "${BOLD_YELLOW}"
    read -p 'Enter Your Choice: ' main_choice
    echo -e "${RESET}"
    
    if [[ $main_choice -eq 1 ]]; then
        # Teacher Portal
        authenticate_t
        teacher_choice=1
        while [[ $teacher_choice -ne 0 ]]; do
            teacher_ka_menu
            echo
            echo -e "${BOLD_YELLOW}"
            read -p 'Enter Your Choice: ' teacher_choice
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
            elif [[ $teacher_choice -eq 12 ]]; then
                credits
            elif [[ $teacher_choice -eq 0 ]]; then
                 unauth_animation
            else
                echo -e "${BOLD_YELLOW}Invalid choice!${RESET}"
            fi
        done
    elif [[ $main_choice -eq 2 ]]; then
        # Student Portal
        if authenticate_s; then
            student_choice=1
            while [[ $student_choice -ne 0 ]]; do
                student_ka_menu 
                echo -e "${BOLD_YELLOW}"
                read -p 'Enter Your Choice: ' student_choice
                echo -e "${RESET}"
                
                if [[ $student_choice -eq 1 ]]; then
                    view_student_grades
                elif [[ $student_choice -eq 2 ]]; then
                    view_student_cgpa
                elif [[ $student_choice -eq 0 ]]; then
                    unauth_animation
                else
                    echo -e "${BOLD_YELLOW}Invalid choice!${RESET}"
                fi
            done
        fi
    elif [[ $main_choice -eq 0 ]]; then
        echo -e "${BOLD_YELLOW}Goodbye!${RESET}"
    else
        echo -e "${BOLD_YELLOW}Invalid choice!${RESET}"
    fi
done