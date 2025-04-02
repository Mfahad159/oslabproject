#!/bin/bash


#          <<<<<<<<< ......... ~ here are color codes & functions ~.......      :)      >>>>>>>>


CYAN='\033[1;36m'
BLUE='\033[1;34m'
RESET='\033[0m'
BOLD_CYAN='\033[1;36m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'

S_FILE="students.txt"
M_FILE="marks.txt"

welcome_menu()
{
    echo -e "${BOLD_CYAN}\n ---------       STUDENT MANAGEMENT SYSTEM       ---------- ${RESET}"
    echo -e "${CYAN}|                                                         |"
    echo -e "|                 1. Teacher Portal                       |"
    echo -e "|                 2. Student Portal                       |"
    echo -e "|                 0. EXIT                                 |"
    echo -e "|                                                         |"
    echo -e " --------------------------------------------------------- ${RESET}"
}

teacher_ka_menu()
{
    echo -e "${BOLD_CYAN}\n ---------       TEACHER PORTAL       ---------- ${RESET}"
    echo -e "${CYAN}|                                                         |"
    echo -e "|                 1. Add New Student                      |"
    echo -e "|                 2. Delete Student                       |"
    echo -e "|                 3. Update Marks                         |"
    echo -e "|                 4. View All Students                    |"
    echo -e "|                 5. View Specific Student Details        |"
    echo -e "|                 6. Calculate Grades & CGPA              |"
    echo -e "|                 7. List Passed Students                 |"
    echo -e "|                 8. List Failed Students                 |"
    echo -e "|                 9. Credits                              |"
    echo -e "|                 0. Back to Main Menu                    |"
    echo -e "|                                                         |"
    echo -e " --------------------------------------------------------- ${RESET}"
}

student_ka_menu()
{
    echo -e "${BOLD_CYAN}\n ---------       STUDENT PORTAL       ---------- ${RESET}"
    echo -e "${CYAN}|                                                         |"
    echo -e "|                 1. View Grades                          |"
    echo -e "|                 2. View CGPA                            |"
    echo -e "|                 0. Back to Main Menu                    |"
    echo -e "|                                                         |"
    echo -e " --------------------------------------------------------- ${RESET}"
}

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

#                         <<<<<<<<< ......... ~ AUTHENTICATIONS FUNCTIONSSS ~.......      :)      >>>>>>>>

authenticate_t()
{
    local input_uname input_pass
    
    while true; do
        echo -e "\n${CYAN}              TEACHER LOGIN  :) ${RESET}"
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

authenticate_s()
{
    local input_id input_name found
    
    echo -e "\n${CYAN}              STUDENT LOGIN  :) ${RESET}"
    read -p "Student ID: " input_id
    read -p "Name: " input_name
    auth_animation
    echo
    
    # Check if student exists
    if grep -q "^$input_id," "$S_FILE" 2>/dev/null; then
        student_name=$(grep "^$input_id," "$S_FILE" | cut -d',' -f2)
        if [[ "$student_name" == "$input_name" ]]; then
            echo -e "${BOLD_GREEN}Authentication Successful!${RESET}"
            student_current_id="$input_id"
            return 0
        fi
    fi
    echo -e "${BOLD_YELLOW}Invalid credentials! Try again.${RESET}"
    return 1
}
#                          <<<<<<<<< ......... ~ CREDITS ~.......      :)      >>>>>>>>
credits()
{
    echo -e "${BOLD_GREEN}\n ---------       CREDITS       ----------${RESET}"
    echo -e "${BOLD_YELLOW}Developed By: Muhammad Fahad${RESET}"
    echo -e " - BSc Computer Science student at FAST University"
    echo -e " - Skilled in C/C++"
    echo -e " - Experience in AI, problem-solving"
    echo
    echo -e "${BOLD_YELLOW}Contributor: Ajmal Razaq Bhatti${RESET}"
    echo -e " - App/Web Designer "
    echo -e " - Passionate about Product development and designing"
}

#                          <<<<<<<<< ......... ~ ADD STUDENT FUNC ~.......      :)      >>>>>>>>

add_student()
{
    echo -e "${BOLD_YELLOW}\nEnter Student Details:"
    read -p "Student ID: " student_id
    read -p "Name: " name
    read -p "Age: " age
    read -p "Department: " department
    echo "$student_id,$name,$age,$department" >> "$S_FILE"
    echo -e "\n${RESET}${BOLD_GREEN}Student Added Successfully!${RESET}"
}

#                          <<<<<<<<< ......... ~ DELETE STUDENT FUNC ~.......      :)      >>>>>>>>

del_student()
{
    echo -e "${BOLD_YELLOW}\nEnter Student ID to delete:${RESET}"
    read -p "Student ID: " student_id
    if grep -q "^$student_id," "$S_FILE"; then
        grep -v "^$student_id," "$S_FILE" > temp.txt
        mv temp.txt "$S_FILE"
        echo -e "${BOLD_GREEN}Student deleted successfully!${RESET}"
    else
        echo -e "${BOLD_YELLOW}Student ID not found!${RESET}"
    fi
}


#                          <<<<<<<<< ......... ~ MARKS UPDATE FUNC ~.......      :)      >>>>>>>>


update_marks()
{
    echo -e "${BOLD_YELLOW}\nEnter Student ID to update marks:${RESET}"
    read -p "Student ID: " student_id
    
    if grep -q "^$student_id," "$S_FILE"; then
        student_info=$(grep "^$student_id," "$S_FILE")
        echo -e "${BOLD_CYAN}Current Info: $student_info${RESET}"
        
        read -p "Enter marks for Subject 1 (out of 100): " sub1
        read -p "Enter marks for Subject 2 (out of 100): " sub2
        read -p "Enter marks for Subject 3 (out of 100): " sub3
        
        if (( sub1 >= 90 )); then
            grade1="A+"
        elif (( sub1 >= 80 )); then
            grade1="A"
        elif (( sub1 >= 70 )); then
            grade1="B"
        elif (( sub1 >= 60 )); then
            grade1="C"
        elif (( sub1 >= 50 )); then
            grade1="D"
        else
            grade1="F"
        fi
        
        if (( sub2 >= 90 )); then
            grade2="A+"
        elif (( sub2 >= 80 )); then
            grade2="A"
        elif (( sub2 >= 70 )); then
            grade2="B"
        elif (( sub2 >= 60 )); then
            grade2="C"
        elif (( sub2 >= 50 )); then
            grade2="D"
        else
            grade2="F"
        fi
        
        if (( sub3 >= 90 )); then
            grade3="A+"
        elif (( sub3 >= 80 )); then
            grade3="A"
        elif (( sub3 >= 70 )); then
            grade3="B"
        elif (( sub3 >= 60 )); then
            grade3="C"
        elif (( sub3 >= 50 )); then
            grade3="D"
        else
            grade3="F"
        fi
        
        # Calculate CGPA
        if [[ "$grade1" == "A+" ]]; then gp1=4.0; 
        elif [[ "$grade1" == "A" ]]; then gp1=3.7; 
        elif [[ "$grade1" == "B" ]]; then gp1=3.0; 
        elif [[ "$grade1" == "C" ]]; then gp1=2.0; 
        elif [[ "$grade1" == "D" ]]; then gp1=1.0; 
        else gp1=0.0; fi
        
        if [[ "$grade2" == "A+" ]]; then gp2=4.0; 
        elif [[ "$grade2" == "A" ]]; then gp2=3.7; 
        elif [[ "$grade2" == "B" ]]; then gp2=3.0; 
        elif [[ "$grade2" == "C" ]]; then gp2=2.0; 
        elif [[ "$grade2" == "D" ]]; then gp2=1.0; 
        else gp2=0.0; fi
        
        if [[ "$grade3" == "A+" ]]; then gp3=4.0; 
        elif [[ "$grade3" == "A" ]]; then gp3=3.7; 
        elif [[ "$grade3" == "B" ]]; then gp3=3.0; 
        elif [[ "$grade3" == "C" ]]; then gp3=2.0; 
        elif [[ "$grade3" == "D" ]]; then gp3=1.0; 
        else gp3=0.0; fi
        
        cgpa=$(echo "scale=2; ($gp1 + $gp2 + $gp3) / 3" | bc)
        
        # Check if marks file exists, create if not
        if [[ ! -f "$M_FILE" ]]; then
            touch "$M_FILE"
        fi
        # Check if student already has marks
        if grep -q "^$student_id," "$M_FILE"; then
            # Update marks
            sed -i "/^$student_id,/c\\$student_id,$sub1,$sub2,$sub3,$grade1,$grade2,$grade3,$cgpa" "$M_FILE"
        else
            # Add new marks
            echo "$student_id,$sub1,$sub2,$sub3,$grade1,$grade2,$grade3,$cgpa" >> "$M_FILE"
        fi
        
        echo -e "${BOLD_GREEN}Marks updated successfully!${RESET}"
    else
        echo -e "${BOLD_YELLOW}Student ID not found!${RESET}"
    fi
}

all_students()
{
    if [[ ! -f "$S_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No student records found!${RESET}"
        return
    fi
    
    echo -e "${BOLD_CYAN}\n ---------       ALL STUDENTS       ---------- ${RESET}"
    echo -e "${CYAN}ID\tName\t\tAge\tDepartment${RESET}"
    echo -e "${CYAN}-------------------------------------------${RESET}"
    
    while IFS=',' read -r id name age department || [[ -n "$id" ]]; do
        # Skip empty lines
        if [[ -z "$id" ]]; then
            continue
        fi
        
        echo -e "${CYAN}$id\t$name\t\t$age\t$department${RESET}"
    done < "$S_FILE"
}

view_1_student()
{
    echo -e "${BOLD_YELLOW}\nEnter Student ID to view:${RESET}"
    read -p "Student ID: " student_id
    
    if grep -q "^$student_id," "$S_FILE"; then
        student_info=$(grep "^$student_id," "$S_FILE")
        id=$(echo "$student_info" | cut -d',' -f1)
        name=$(echo "$student_info" | cut -d',' -f2)
        age=$(echo "$student_info" | cut -d',' -f3)
        department=$(echo "$student_info" | cut -d',' -f4)
        
        echo -e "${BOLD_CYAN}\n ---------       STUDENT DETAILS       ---------- ${RESET}"
        echo -e "${CYAN}ID: $id${RESET}"
        echo -e "${CYAN}Name: $name${RESET}"
        echo -e "${CYAN}Age: $age${RESET}"
        echo -e "${CYAN}Department: $department${RESET}"
        
        # Check if marks exist
        if [[ -f "$M_FILE" ]] && grep -q "^$student_id," "$M_FILE"; then
            marks_info=$(grep "^$student_id," "$M_FILE")
            sub1=$(echo "$marks_info" | cut -d',' -f2)
            sub2=$(echo "$marks_info" | cut -d',' -f3)
            sub3=$(echo "$marks_info" | cut -d',' -f4)
            grade1=$(echo "$marks_info" | cut -d',' -f5)
            grade2=$(echo "$marks_info" | cut -d',' -f6)
            grade3=$(echo "$marks_info" | cut -d',' -f7)
            cgpa=$(echo "$marks_info" | cut -d',' -f8)
            
            echo -e "${BOLD_CYAN}\n ---------       ACADEMIC DETAILS       ---------- ${RESET}"
            echo -e "${CYAN}Subject 1: $sub1/100 (Grade: $grade1)${RESET}"
            echo -e "${CYAN}Subject 2: $sub2/100 (Grade: $grade2)${RESET}"
            echo -e "${CYAN}Subject 3: $sub3/100 (Grade: $grade3)${RESET}"
            echo -e "${CYAN}CGPA: $cgpa${RESET}"
        else
            echo -e "${BOLD_YELLOW}No marks data available for this student.${RESET}"
        fi
    else
        echo -e "${BOLD_YELLOW}Student ID not found!${RESET}"
    fi
}

passed_students()
{
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No student records or marks found!${RESET}"
        return
    fi
    
    echo -e "${BOLD_GREEN}\n ---------       PASSED STUDENTS       ---------- ${RESET}"
    echo -e "${CYAN}ID\tName\t\tDepartment\tCGPA${RESET}"
    echo -e "${CYAN}-------------------------------------------${RESET}"
    
    while IFS=',' read -r id sub1 sub2 sub3 grade1 grade2 grade3 cgpa || [[ -n "$id" ]]; do
        # Skip empty lines
        if [[ -z "$id" ]]; then
            continue
        fi
        
        # Check if student passed (CGPA >= 2.0)
        if (( $(echo "$cgpa >= 2.0" | bc -l) )); then
            student_info=$(grep "^$id," "$S_FILE")
            name=$(echo "$student_info" | cut -d',' -f2)
            department=$(echo "$student_info" | cut -d',' -f4)
            
            echo -e "${CYAN}$id\t$name\t\t$department\t$cgpa${RESET}"
        fi
    done < "$M_FILE"
}

failed_students()
{
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No student records or marks found!${RESET}"
        return
    fi
    
    echo -e "${BOLD_YELLOW}\n ---------       FAILED STUDENTS       ---------- ${RESET}"
    echo -e "${CYAN}ID\tName\t\tDepartment\tCGPA${RESET}"
    echo -e "${CYAN}-------------------------------------------${RESET}"
    
    while IFS=',' read -r id sub1 sub2 sub3 grade1 grade2 grade3 cgpa || [[ -n "$id" ]]; do
        # Skip empty lines
        if [[ -z "$id" ]]; then
            continue
        fi
        
        # Check if student failed (CGPA < 2.0)
        if (( $(echo "$cgpa < 2.0" | bc -l) )); then
            student_info=$(grep "^$id," "$S_FILE")
            name=$(echo "$student_info" | cut -d',' -f2)
            department=$(echo "$student_info" | cut -d',' -f4)
            
            echo -e "${CYAN}$id\t$name\t\t$department\t$cgpa${RESET}"
        fi
    done < "$M_FILE"
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
    name=$(echo "$student_info" | cut -d',' -f2)
    
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
    name=$(echo "$student_info" | cut -d',' -f2)
    
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






#                                    <<<<<<<<< ......... ~ Here MAIN is Starting ~ .......      :)      >>>>>>>>





echo -e "\n${BOLD_YELLOW}  -------- ~  WELL..WELL..WELCOMEEE :)  ~  --------${RESET}"

main_choice=1
while [[ $main_choice -ne 0 ]]; do
    welcome_menu
    echo
    read -p '        ==> ' main_choice
    
    if [[ $main_choice -eq 1 ]]; then
        # Teacher Portal
        authenticate_t
        teacher_choice=1
        while [[ $teacher_choice -ne 0 ]]; do
            teacher_ka_menu
            echo
            read -p '        ==> ' teacher_choice
            
            if [[ $teacher_choice -eq 1 ]]; then
                add_student
            elif [[ $teacher_choice -eq 2 ]]; then
                del_student
            elif [[ $teacher_choice -eq 3 ]]; then
                update_marks
            elif [[ $teacher_choice -eq 4 ]]; then
                all_students
            elif [[ $teacher_choice -eq 5 ]]; then
                view_1_student
            elif [[ $teacher_choice -eq 6 ]]; then
                echo -e "${BOLD_GREEN}Calculating grades and CGPA for all students...${RESET}"
            elif [[ $teacher_choice -eq 7 ]]; then
                passed_students
            elif [[ $teacher_choice -eq 8 ]]; then
                failed_students
            elif [[ $teacher_choice -eq 9 ]]; then
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
                student_menu
                echo
                read -p '        ==> ' student_choice
                
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