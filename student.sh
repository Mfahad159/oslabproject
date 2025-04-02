#!/bin/bash

# Make sure these variables are available from main.sh
# BOLD_CYAN, BOLD_GREEN, BOLD_YELLOW, RESET, S_FILE, M_FILE should be defined in main.sh

student_ka_menu()
{
    echo -e "${BOLD_CYAN}\nSTUDENT PORTAL${RESET}"  # Fixed typo in "STUDENT"
    echo -e "1. View Grades"
    echo -e "2. View CGPA"
    echo -e "0. Back to Main Menu"
    echo -e  "${RESET}"
}

view_student_grades()
{
    if [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No grades found for your account!${RESET}"
        return
    fi
    
    # Get student marks
    student_marks=$(grep "^$student_current_id," "$M_FILE")
    
    if [[ -z "$student_marks" ]]; then
        echo -e "${BOLD_YELLOW}No grades found for your account!${RESET}"
        return
    fi
    
    student_info=$(grep "^$student_current_id," "$S_FILE")
    name=$(echo "$student_info" | cut -d',' -f3)
    
    # Parse marks and grades
    sub1=$(echo "$student_marks" | cut -d',' -f2)
    sub2=$(echo "$student_marks" | cut -d',' -f3)
    sub3=$(echo "$student_marks" | cut -d',' -f4)
    grade1=$(echo "$student_marks" | cut -d',' -f5)
    grade2=$(echo "$student_marks" | cut -d',' -f6)
    grade3=$(echo "$student_marks" | cut -d',' -f7)
    
    echo -e "${BOLD_CYAN}\n ---------       YOUR GRADES       ---------- ${RESET}"
    echo -e "${CYAN}Student: $name (ID: $student_current_id)${RESET}"
    echo -e "${CYAN}-------------------------------------------${RESET}"
    echo -e "${CYAN}Subject 1: $sub1/100 (Grade: $grade1)${RESET}"
    echo -e "${CYAN}Subject 2: $sub2/100 (Grade: $grade2)${RESET}"
    echo -e "${CYAN}Subject 3: $sub3/100 (Grade: $grade3)${RESET}"
}

view_student_cgpa()
{
    if [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No CGPA found for your account!${RESET}"
        return
    fi
    
    # Get student marks
    student_marks=$(grep "^$student_current_id," "$M_FILE")
    
    if [[ -z "$student_marks" ]]; then
        echo -e "${BOLD_YELLOW}No CGPA found for your account!${RESET}"
        return
    fi
    
    student_info=$(grep "^$student_current_id," "$S_FILE")
    name=$(echo "$student_info" | cut -d',' -f3)
    
    # Parse CGPA
    cgpa=$(echo "$student_marks" | cut -d',' -f8)
    
    echo -e "${BOLD_CYAN}\n ---------       YOUR CGPA       ---------- ${RESET}"
    echo -e "${CYAN}Student: $name (ID: $student_current_id)${RESET}"
    echo -e "${CYAN}-------------------------------------------${RESET}"
    echo -e "${CYAN}Your CGPA: $cgpa${RESET}"
    
    # Add a status message based on CGPA
    echo
    if (( $(echo "$cgpa >= 3.7" | bc -l) )); then
        echo -e "${BOLD_GREEN}Status: Excellent Performance!${RESET}"
    elif (( $(echo "$cgpa >= 3.0" | bc -l) )); then
        echo -e "${BOLD_GREEN}Status: Very Good Performance!${RESET}"
    elif (( $(echo "$cgpa >= 2.0" | bc -l) )); then
        echo -e "${BOLD_YELLOW}Status: Satisfactory Performance${RESET}"
    else
        echo -e "${BOLD_YELLOW}Status: Need Improvement (Failed)${RESET}"
    fi
}