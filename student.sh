#!/bin/bash
# ----------------
# FUNCTIONS OVERVIEW:
# -----------------
# student_ka_menu(): Displays the student portal menu options
# view_student_grades(): Shows the student's grades for each subject
# view_student_cgpa(): Shows the student's overall CGPA and performance status



#student menu #################################################################
student_ka_menu()
{
    echo -e "${BOLD_YELLOW}Welcome To Student Portal ${student_current_id}\n ${RESET}"
    echo -e "[01] View Grades"
    echo -e "[02] View CGPA"
    echo -e "[00] Log Out"
    echo -e  "${RESET}"
}
#############################################################################




#Functions to view grades ################################################
view_student_grades()
{
    clear
    if [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No Grades Found For Your Account!${RESET}"
        return
    fi
    
    # Get student marks
    student_marks=$(grep "^$student_current_id," "$M_FILE")
    
    if [[ -z "$student_marks" ]]; then
        echo -e "${BOLD_YELLOW}No Grades Found For Your Account!${RESET}"
        return
    fi
    
    student_info=$(grep "^$student_current_id," "$S_FILE")
    name=$(echo "$student_info" | cut -d',' -f2)
    
    # Parse marks and grades
    sub1=$(echo "$student_marks" | cut -d',' -f2)
    sub2=$(echo "$student_marks" | cut -d',' -f3)
    sub3=$(echo "$student_marks" | cut -d',' -f4)
    grade1=$(echo "$student_marks" | cut -d',' -f5)
    grade2=$(echo "$student_marks" | cut -d',' -f6)
    grade3=$(echo "$student_marks" | cut -d',' -f7)
    
    echo -e "${CYAN}---------------------------------------- ${RESET}"
    echo -e "${CYAN}Student: $name (ID: $student_current_id)${RESET}"
    echo -e "${CYAN}-----------------------------------------${RESET}"
    
    # Check if grades have been calculated
    if [[ "$grade1" == "N/A" || "$grade2" == "N/A" || "$grade3" == "N/A" ]]; then
        echo -e "${BOLD_YELLOW}Your Grades Have Not Been Updated By The Teacher yet!${RESET}"
        echo -e "${CYAN}Raw Marks:${RESET}"
        echo -e "${CYAN}OS: $sub1/100${RESET}"
        echo -e "${CYAN}DB: $sub2/100${RESET}"
        echo -e "${CYAN}PROB: $sub3/100${RESET}"
    else
        echo -e "${CYAN}OS: $sub1/100 (Grade: $grade1)${RESET}"
        echo -e "${CYAN}DB: $sub2/100 (Grade: $grade2)${RESET}"
        echo -e "${CYAN}PROB: $sub3/100 (Grade: $grade3)${RESET}"
    fi
}
##############################################################################






#Functions to view CGPA ######################################################
view_student_cgpa()
{
    clear
    if [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No CGPA Found For Your Account!${RESET}"
        return
    fi
    
    # Get student marks
    student_marks=$(grep "^$student_current_id," "$M_FILE")
    
    if [[ -z "$student_marks" ]]; then
        echo -e "${BOLD_YELLOW}No CGPA Found For Your Account!${RESET}"
        return
    fi
    
    student_info=$(grep "^$student_current_id," "$S_FILE")
    name=$(echo "$student_info" | cut -d',' -f2)
    
    # Parse CGPA
    cgpa=$(echo "$student_marks" | cut -d',' -f8)
     
    if [[ "$cgpa" == "N/A" ]]; then
        echo -e "${BOLD_YELLOW}CGPA is Not Updated By The Teacher Yet!!${RESET}"
        return
    fi
    
    echo -e "${CYAN}------------------------------------------- ${RESET}"
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
##############################################################################