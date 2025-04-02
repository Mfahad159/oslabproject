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
BOLD_YELLOW='\033[1;33m'

# file paths
S_FILE="students.txt"
M_FILE="marks.txt"


# unction to display the welcome menu
welcome_menu()
{
    echo -e "1. Teacher Portal"
    echo -e "2. Student Portal"
    echo -e "0. EXIT"
    echo -e  "${RESET}"
}

# function to dispaly authentication animation
auth_animation() 
{
    echo -ne "\n               "
    echo -ne "${BOLD_GREEN}\nAUTHENICATING: "
    for ((i=0; i<20; i++)); do
        sleep 0.02
        echo -ne "▓"
    done
    echo -ne "${RESET}"
}

teacher_uname="mian"
teacher_pass="123"

# Add these simple encryption/decryption functions near the top of your script
encrypt_password() {
    local password="$1"
    local encrypted=""
    # Simple shift cipher - shift each character by 3 positions in ASCII
    for (( i=0; i<${#password}; i++ )); do
        char="${password:$i:1}"
        # Convert to ASCII value, add 3, and convert back to character
        encrypted+=$(printf \\$(printf '%03o' $(($(printf '%d' "'$char") + 3))))
    done
    echo "$encrypted"
}

decrypt_password() {
    local encrypted="$1"
    local decrypted=""
    # Reverse the shift cipher - shift each character back by 3 positions
    for (( i=0; i<${#encrypted}; i++ )); do
        char="${encrypted:$i:1}"
        # Convert to ASCII value, subtract 3, and convert back to character
        decrypted+=$(printf \\$(printf '%03o' $(($(printf '%d' "'$char") - 3))))
    done
    echo "$decrypted"
}



#Authentication function for teacher
authenticate_t()
{
    local input_uname input_pass
    while true; do
        echo -e "\n${CYAN}TEACHER LOGIN${RESET}"
        read -p "Username: " input_uname
        read -p "Password: " input_pass
        auth_animation
        echo
        if [[ "$input_uname" == "$teacher_uname" && "$input_pass" == "$teacher_pass" ]]; then
            echo -e "${BOLD_GREEN}Successfully Signed In!${RESET}"
            return 0
        else
            echo -e "${BOLD_YELLOW}Invalid credentials! Try again.${RESET}"
        fi
    done
}



#Authentication function for student
authenticate_s()
{
    local input_id input_password found
    echo -e "\n${CYAN}              STUDENT LOGIN  :) ${RESET}"
    read -p "Student ID: " input_id
    read -p "Password: " input_password
    auth_animation
    echo
    
    # Check if student exists
    if grep -q "^$input_id," "$S_FILE" 2>/dev/null; then
        encrypted_password=$(grep "^$input_id," "$S_FILE" | head -1 | cut -d',' -f2)
        decrypted_password=$(decrypt_password "$encrypted_password")
        
        if [[ "$decrypted_password" == "$input_password" ]]; then
            echo -e "${BOLD_GREEN}Authentication Successful!${RESET}"
            student_current_id="$input_id"
            return 0
        fi
    fi
    echo -e "${BOLD_YELLOW}Invalid credentials! Try again.${RESET}"
    return 1
}

# Main script execution
echo -e "\n${BOLD_YELLOW}Welcome to Student Management Software By Fahad & Ajmal${RESET}"

main_choice=1
while [[ $main_choice -ne 0 ]]; do
    welcome_menu
    echo
    read -p '> ' main_choice
    
    if [[ $main_choice -eq 1 ]]; then
        # Teacher Portal
        authenticate_t
        teacher_choice=1
        while [[ $teacher_choice -ne 0 ]]; do
            teacher_ka_menu
            echo
            read -p '> ' teacher_choice
            
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
                echo -e "${BOLD_YELLOW}Returning to main menu...${RESET}"
            else
                echo -e "${BOLD_YELLOW}Invalid choice!${RESET}"
            fi
        done
    elif [[ $main_choice -eq 2 ]]; then
        # Student Portal
        if authenticate_s; then
            student_choice=1
            while [[ $student_choice -ne 0 ]]; do
                student_ka_menu  # Fixed function name here
                echo
                read -p '> ' student_choice
                
                if [[ $student_choice -eq 1 ]]; then
                    view_student_grades
                elif [[ $student_choice -eq 2 ]]; then
                    view_student_cgpa
                elif [[ $student_choice -eq 0 ]]; then
                    echo -e "${BOLD_YELLOW}Returning to main menu...${RESET}"
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