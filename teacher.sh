#!/bin/bash

# Make sure these variables are available from main.sh
teacher_ka_menu()
{
    echo -e "${BOLD_CYAN}\nTEACHER PORTAL${RESET}"
    echo -e "1. Add New Student"
    echo -e "2. Delete Student"
    echo -e "3. Assign Marks"
    echo -e "4. Calculate Grades"
    echo -e "5. Calculate CGPA"
    echo -e "6. List Passed Students"
    echo -e "7. List Failed Students"
    echo -e "8. List Students by CGPA (Ascending Order)"
    echo -e "9. List Students by CGPA (Descending Order)"
    echo -e "12. Credits"
    echo -e "0. Back to Main Menu"
    echo -e  "${RESET}"
}

#Credits function     
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

#Add student function
add_student()
{
    # Check if student limit is reached (20 students)
    if [[ -f "$S_FILE" ]]; then
        student_count=$(grep -c "^" "$S_FILE")
        if [[ $student_count -ge 20 ]]; then
            echo -e "${BOLD_YELLOW}\nStudent limit reached (20)! Cannot add more students.${RESET}"
            return
        fi
    fi

    echo -e "${BOLD_YELLOW}\nEnter Student Details:"
    read -p "Student ID: " student_id
    read -p "Password: " password
    # Check if student ID already exists
    if grep -q "^$student_id," "$S_FILE"; then
        echo -e "${BOLD_YELLOW}Student ID already exists!${RESET}"
        return
    fi
    # Encrypt the password before storing
    encrypted_password=$(encrypt_password "$password")
    # Append new student details to the file
    echo -e "${BOLD_YELLOW}Enter Student Personal Details:${RESET}"
    # Read personal details
    read -p "Name: " name
    read -p "Age: " age
    read -p "Department: " department
    echo "$student_id,$encrypted_password,$name,$age,$department" >> "$S_FILE"
    
    # Display remaining slots
    remaining=$((20 - $(grep -c "^" "$S_FILE")))
    echo -e "\n${RESET}${BOLD_GREEN}Student Added Successfully!${RESET}"
    echo -e "${BOLD_CYAN}Remaining student slots: $remaining${RESET}"
}

#Delete student function  
del_student() {
    echo -e "\n${CYAN}DELETE STUDENT${RESET}"
    read -p "Enter Student ID to delete: " del_id
    
    if grep -q "^$del_id," "$S_FILE"; then
        # Get student name for confirmation message
        student_name=$(grep "^$del_id," "$S_FILE" | cut -d',' -f3)
        
        # Delete from students file using sed for in-place editing
        sed -i "/^$del_id,/d" "$S_FILE"
        
        # Also delete marks for this student if marks file exists
        if [[ -f "$M_FILE" ]]; then
            sed -i "/^$del_id,/d" "$M_FILE"
        fi
        
        echo -e "${BOLD_GREEN}Student $student_name (ID: $del_id) has been deleted along with their marks records.${RESET}"
    else
        echo -e "${BOLD_YELLOW}Student with ID $del_id not found!${RESET}"
    fi
}

# Assign marks function (simplified version that only assigns marks)
assign_marks()
{
    echo -e "${BOLD_YELLOW}\nEnter Student ID to assign marks:${RESET}"
    read -p "Student ID: " student_id
    
    if grep -q "^$student_id," "$S_FILE"; then
        student_info=$(grep "^$student_id," "$S_FILE")
        name=$(echo "$student_info" | cut -d',' -f3)
        echo -e "${BOLD_CYAN}Assigning marks for: $name (ID: $student_id)${RESET}"
        
        read -p "Enter marks for Subject 1 (out of 100): " sub1
        read -p "Enter marks for Subject 2 (out of 100): " sub2
        read -p "Enter marks for Subject 3 (out of 100): " sub3
        
        # Check if marks file exists, create if not
        if [[ ! -f "$M_FILE" ]]; then
            touch "$M_FILE"
        fi
        
        # Check if student already has marks
        if grep -q "^$student_id," "$M_FILE"; then
            # Get existing grade and CGPA values to preserve them
            existing_marks=$(grep "^$student_id," "$M_FILE")
            grade1=$(echo "$existing_marks" | cut -d',' -f5)
            grade2=$(echo "$existing_marks" | cut -d',' -f6)
            grade3=$(echo "$existing_marks" | cut -d',' -f7)
            cgpa=$(echo "$existing_marks" | cut -d',' -f8)
            
            # Update marks only, keeping existing grades and CGPA
            sed -i "/^$student_id,/c\\$student_id,$sub1,$sub2,$sub3,$grade1,$grade2,$grade3,$cgpa" "$M_FILE"
        else
            # Add new marks entry with placeholder values for grades and CGPA
            echo "$student_id,$sub1,$sub2,$sub3,N/A,N/A,N/A,0.00" >> "$M_FILE"
        fi
        
        echo -e "${BOLD_GREEN}Marks assigned successfully!${RESET}"
        echo -e "${BOLD_YELLOW}Note: Use 'Calculate Grades' and 'Calculate CGPA' functions to update grade and CGPA values.${RESET}"
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
    
    while IFS=',' read -r id password name age department || [[ -n "$id" ]]; do
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
        password=$(echo "$student_info" | cut -d',' -f2)
        name=$(echo "$student_info" | cut -d',' -f3)
        age=$(echo "$student_info" | cut -d',' -f4)
        department=$(echo "$student_info" | cut -d',' -f5)
        
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
            name=$(echo "$student_info" | cut -d',' -f3)
            department=$(echo "$student_info" | cut -d',' -f5)
            
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
            name=$(echo "$student_info" | cut -d',' -f3)
            department=$(echo "$student_info" | cut -d',' -f5)
            
            echo -e "${CYAN}$id\t$name\t\t$department\t$cgpa${RESET}"
        fi
    done < "$M_FILE"
}

# Function to list students in ascending order of CGPA
list_students_asc_cgpa()
{
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No student records or marks found!${RESET}"
        return
    fi
    
    echo -e "${BOLD_CYAN}\n ---------  STUDENTS BY CGPA (ASCENDING)  ---------- ${RESET}"
    echo -e "${CYAN}ID\tName\t\tDepartment\tCGPA${RESET}"
    echo -e "${CYAN}-------------------------------------------${RESET}"
    
    # Create a temporary file with sorted data
    sort -t',' -k8 -n "$M_FILE" > temp_sort.txt
    
    while IFS=',' read -r id sub1 sub2 sub3 grade1 grade2 grade3 cgpa || [[ -n "$id" ]]; do
        # Skip empty lines
        if [[ -z "$id" ]]; then
            continue
        fi
        
        student_info=$(grep "^$id," "$S_FILE")
        name=$(echo "$student_info" | cut -d',' -f3)
        department=$(echo "$student_info" | cut -d',' -f5)
        
        echo -e "${CYAN}$id\t$name\t\t$department\t$cgpa${RESET}"
    done < temp_sort.txt
    
    # Remove temporary file
    rm temp_sort.txt
}



# Function to list students in descending order of CGPA
list_students_desc_cgpa()
{
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No student records or marks found!${RESET}"
        return
    fi
    
    echo -e "${BOLD_CYAN}\n ---------  STUDENTS BY CGPA (DESCENDING)  ---------- ${RESET}"
    echo -e "${CYAN}ID\tName\t\tDepartment\tCGPA${RESET}"
    echo -e "${CYAN}-------------------------------------------${RESET}"
    
    # Create a temporary file with sorted data
    sort -t',' -k8 -nr "$M_FILE" > temp_sort.txt
    
    while IFS=',' read -r id sub1 sub2 sub3 grade1 grade2 grade3 cgpa || [[ -n "$id" ]]; do
        # Skip empty lines
        if [[ -z "$id" ]]; then
            continue
        fi
        
        student_info=$(grep "^$id," "$S_FILE")
        name=$(echo "$student_info" | cut -d',' -f3)
        department=$(echo "$student_info" | cut -d',' -f5)
        
        echo -e "${CYAN}$id\t$name\t\t$department\t$cgpa${RESET}"
    done < temp_sort.txt
    
    # Remove temporary file
    rm temp_sort.txt
}

# Function to calculate grades for all students
calculate_grades() 
{
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No student records or marks found!${RESET}"
        return
    fi
    
    echo -e "${BOLD_CYAN}\n ---------  CALCULATING GRADES FOR ALL STUDENTS  ---------- ${RESET}"
    
    # Create a temporary file for the updated marks
    > temp_marks.txt
    
    while IFS=',' read -r id sub1 sub2 sub3 old_grade1 old_grade2 old_grade3 old_cgpa || [[ -n "$id" ]]; do
        # Skip empty lines
        if [[ -z "$id" ]]; then
            continue
        fi
        
        # Calculate grades for each subject
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
        
        # Add to temporary file (keep the old CGPA for now)
        echo "$id,$sub1,$sub2,$sub3,$grade1,$grade2,$grade3,$old_cgpa" >> temp_marks.txt
        
        # Get student name for output
        student_info=$(grep "^$id," "$S_FILE")
        name=$(echo "$student_info" | cut -d',' -f3)
        
        echo -e "${CYAN}Grades calculated for $name (ID: $id)${RESET}"
    done < "$M_FILE"
    
    # Replace the original file with the updated one
    mv temp_marks.txt "$M_FILE"
    
    echo -e "${BOLD_GREEN}All grades have been recalculated successfully!${RESET}"
}

# Function to calculate CGPA for all students
calculate_cgpa() 
{
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No student records or marks found!${RESET}"
        return
    fi
    
    echo -e "${BOLD_CYAN}\n ---------  CALCULATING CGPA FOR ALL STUDENTS  ---------- ${RESET}"
    
    # Create a temporary file for the updated CGPA
    > temp_marks.txt
    
    while IFS=',' read -r id sub1 sub2 sub3 grade1 grade2 grade3 old_cgpa || [[ -n "$id" ]]; do
        # Skip empty lines
        if [[ -z "$id" ]]; then
            continue
        fi
        
        # Calculate grade points for each grade
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
        
        # Calculate CGPA
        cgpa=$(echo "scale=2; ($gp1 + $gp2 + $gp3) / 3" | bc)
        
        # Add to temporary file
        echo "$id,$sub1,$sub2,$sub3,$grade1,$grade2,$grade3,$cgpa" >> temp_marks.txt
        
        # Get student name for output
        student_info=$(grep "^$id," "$S_FILE")
        name=$(echo "$student_info" | cut -d',' -f3)
        
        echo -e "${CYAN}CGPA calculated for $name (ID: $id): $cgpa${RESET}"
    done < "$M_FILE"
    
    # Replace the original file with the updated one
    mv temp_marks.txt "$M_FILE"
    
    echo -e "${BOLD_GREEN}All CGPAs have been recalculated successfully!${RESET}"
}