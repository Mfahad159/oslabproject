#!/bin/bash
#------------------
# FUNCTION OVERVIEW:
# -----------------
# teacher_ka_menu(): Displays the teacher portal menu options
# add_student(): Adds a new student with ID, password, and personal details
# del_student(): Removes a student and all associated records
# assign_marks(): Assigns marks for OS, DB, and PROB subjects
# calculate_grades(): Calculates letter grades based on numeric marks
# calculate_cgpa(): Calculates CGPA based on letter grades
# all_students(): Lists all students currently in the system
# passed_students(): Lists all students with CGPA >= 2.0
# failed_students(): Lists all students with CGPA < 2.0
# list_students_asc_cgpa(): Lists students in ascending order of CGPA
# list_students_desc_cgpa(): Lists students in descending order of CGPA



#Teacher Menu Show ############################################################
teacher_ka_menu()
{
    clear
    echo -e "${BOLD_YELLOW}Welcome ${teacher_name} to Teacher Portal\n${RESET}"
    echo -e "[01] Add New Student"
    echo -e "[02] Delete Student"
    echo -e "[03] Assign Marks"
    echo -e "[04] Calculate Grades"
    echo -e "[05] Calculate CGPA"
    echo -e "[06] List Passed Students"
    echo -e "[07] List Failed Students"
    echo -e "[08] List Students by CGPA (Ascending Order)"
    echo -e "[09] List Students by CGPA (Descending Order)"
    echo -e "[00] Log Out"
    echo -e  "${RESET}"
}
#############################################################################





#Add student function ##################################################
add_student()
{
    clear
    if [[ -f "$S_FILE" ]]; then
    #count num of students already in file
        student_count=$(grep -c "^" "$S_FILE")
        if [[ $student_count -ge 20 ]]; then
            echo -e "${BOLD_RED}\nStudent Limit Reached (20)! Cannot Add More students${RESET}"
            return
        fi
    fi


    echo -e "${BOLD_YELLOW}\nEnter Student Details:${RESET}"
    read -p "Student ID: " student_id
    # Empty ID validation
    while [[ -z "$student_id" ]]; do
        echo -e "${BOLD_RED}Student ID Cannot Be Empty!${RESET}"
        read -p "Student ID: " student_id
    done

    read -p "Password: " password
    # Empty password validation
    while [[ -z "$password" ]]; do
        echo -e "${BOLD_RED}Password Cannot Be Empty!${RESET}"
        read -p "Password: " password
    done

    
    # Check if student ID already exists in auth file
    if grep -q "^$student_id," "$AUTH_FILE" 2>/dev/null; then
        echo -e "${BOLD_YELLOW}Student Already Exist!${RESET}"
        return
    fi


    #store student id and password in auth file
    echo "$student_id,$password" >> "$AUTH_FILE"
    echo -e "${BOLD_YELLOW}Enter Student Personal Details:${RESET}"


    read -p "Name: " name
    # Empty name validation
    while [[ -z "$name" ]]; do
        echo -e "${BOLD_RED}Name Cannot Be Empty!${RESET}"
        read -p "Name: " name
    done


    read -p "Age: " age
    # Empty age validation
    while [[ -z "$age" ]]; do
        echo -e "${BOLD_RED}Age Cannot Be Empty!${RESET}"
        read -p "Age: " age
    done


    read -p "Department: " department
    # Empty department validation
    while [[ -z "$department" ]]; do
        echo -e "${BOLD_RED}Department Cannot Be Empty!${RESET}"
        read -p "Department: " department
    done
    echo "$student_id,$name,$age,$department" >> "$S_FILE"

    #showing remianing spots
    remaining=$((20 - $(grep -c "^" "$S_FILE")))
    clear
    echo -e "\n${RESET}${BOLD_GREEN}Student Added Successfully!${RESET}"
    echo -e "${CYAN}Remaining Student Slots: $remaining${RESET}"
    echo -e "Press Enter To Return To Main Menu..."
    read -r
}
#############################################################################







#Delete student function ################################################
del_student() {
    clear
    read -p "Enter Student ID To Delete: " del_id
    # Empty ID validation
    while [[ -z "$del_id" ]]; do
        echo -e "${BOLD_RED}Student ID Cannot Be Empty!${RESET}"
        read -p "Enter Student ID To Delete: " del_id
    done

    if grep -q "^$del_id," "$S_FILE"; then
        # Get student name for confirmation message
        student_name=$(grep "^$del_id," "$S_FILE" | cut -d',' -f2)
        
        # Delete from students file and auth file
        sed -i "/^$del_id,/d" "$S_FILE"
        sed -i "/^$del_id,/d" "$AUTH_FILE"
        
        # Also delete marks for this student if marks file exists
        if [[ -f "$M_FILE" ]]; then
            sed -i "/^$del_id,/d" "$M_FILE"
        fi
        
        echo -e "${BOLD_GREEN}Student $student_name (ID: $del_id) Has Been Deleted Along With Their Records.${RESET}"
    else
        echo -e "${BOLD_YELLOW}Student with ID $del_id Not Found!${RESET}"
    fi
    echo -e "Press Enter To Return To Main Menu..."
    read -r
}
#############################################################################






# Assign marks function #######################################################
assign_marks()
{
    clear
    all_students
    echo -e "${BOLD_YELLOW}\nEnter Student ID To Assign Marks:${RESET}"
    read -p "Student ID: " student_id
    
    # Empty ID validation
    while [[ -z "$student_id" ]]; do
        echo -e "${BOLD_RED}Student ID Cannot Be Empty!${RESET}"
        read -p "Student ID: " student_id
    done
    
    if grep -q "^$student_id," "$S_FILE"; then
        student_info=$(grep "^$student_id," "$S_FILE")
        name=$(echo "$student_info" | cut -d',' -f3)
        echo -e "${CYAN}Assigning Marks For: $name (ID: $student_id)${RESET}"
        
        # Get marks for subjects
        while true; do
            read -p "Enter Marks For OS: " sub1
            # Empty marks validation
            while [[ -z "$sub1" ]]; do
                echo -e "${BOLD_RED}Marks Cannot Be Empty!${RESET}"
                read -p "Enter Marks For OS: " sub1
            done
            
            if [[ "$sub1" =~ ^[0-9]+$ ]] && [ "$sub1" -ge 0 ] && [ "$sub1" -le 100 ]; then
                break
            else
                 echo -e "${BOLD_YELLOW}Invalid Input! Please Enter A Number Between 0 and 100.${RESET}"
            fi
        done

        while true; do
            read -p "Enter Marks For DB: " sub2
            # Empty marks validation
            while [[ -z "$sub2" ]]; do
                echo -e "${BOLD_RED}Marks Cannot Be Empty!${RESET}"
                read -p "Enter Marks For DB: " sub2
            done
            
            if [[ "$sub2" =~ ^[0-9]+$ ]] && [ "$sub2" -ge 0 ] && [ "$sub2" -le 100 ]; then
                break
            else
                 echo -e "${BOLD_YELLOW}Invalid Input! Please Enter A Number Between 0 and 100.${RESET}"
            fi
        done

        while true; do
            read -p "Enter Marks For PROB: " sub3
            # Empty marks validation
            while [[ -z "$sub3" ]]; do
                echo -e "${BOLD_RED}Marks Cannot Be Empty!${RESET}"
                read -p "Enter Marks For PROB: " sub3
            done
            
            if [[ "$sub3" =~ ^[0-9]+$ ]] && [ "$sub3" -ge 0 ] && [ "$sub3" -le 100 ]; then
                break
            else
                echo -e "${BOLD_YELLOW}Invalid Input! Please Enter A Number Between 0 and 100.${RESET}"
            fi
        done
        
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
            echo "$student_id,$sub1,$sub2,$sub3,N/A,N/A,N/A,N/A" >> "$M_FILE"
        fi
        
        echo -e "${BOLD_GREEN}Marks Assigned Successfully!${RESET}"
        echo -e "${BOLD_YELLOW}Note: Use 'Calculate Grades' and 'Calculate CGPA' Functions TO Update Grade and CGPA values.${RESET}"
        echo -e "Press Enter To Return To Main Menu..."
    read -r
    else
        echo -e "${BOLD_RED}Student ID Not Found!${RESET}"
        echo -e "Press Enter To Return To Main Menu..."
    read -r
    fi
}
#############################################################################










#function to show all students in data ########################################
all_students()
{ 
    if [[ ! -f "$S_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No Student Records Found!${RESET}"
        return
    fi
    echo -e "${CYAN}ID\tName\t\tAge\tDepartment${RESET}"
    echo -e "${CYAN}-------------------------------------------${RESET}"
    while IFS=',' read -r id name age department || [[ -n "$id" ]]; do
        # Skip empty lines
        if [[ -z "$id" ]]; then
            continue
        fi
        echo -e "${CYAN}$id\t$name\t\t$age\t$department${RESET}"
    done < "$S_FILE"
    student_count=$(grep -c "^" "$S_FILE")
    echo -e "\n${CYAN}Total Students: $student_count / 20${RESET}"
}
#############################################################################










#function to show all passed students whose cgpa => 2 ######################
passed_students()
{
    clear
    # Check if student records and marks files exist
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No Student Records Or Marks Found!${RESET}"
        return
    fi
    
    # Flag to check if any passed students are found
    local passed_found=0
    local passed_students=()
    local passed_names=()
    local passed_departments=()
    local passed_cgpas=()
    
    while IFS=',' read -r id sub1 sub2 sub3 grade1 grade2 grade3 cgpa || [[ -n "$id" ]]; do
        # Skip empty lines or records with N/A CGPA
        if [[ -z "$id" || "$cgpa" == "N/A" ]]; then
            continue
        fi
        # Check if student passed (CGPA >= 2.0)
        if (( $(echo "$cgpa >= 2.0" | bc -l) )); then
            student_info=$(grep "^$id," "$S_FILE")
            name=$(echo "$student_info" | cut -d',' -f2)
            department=$(echo "$student_info" | cut -d',' -f4)
            
            # Add passed student details to arrays
            passed_students+=("$id")
            passed_names+=("$name")
            passed_departments+=("$department")
            passed_cgpas+=("$cgpa")
            passed_found=1
        fi
    done < "$M_FILE"
    
    
    # Only show table if we found passed students
    if [[ $passed_found -eq 1 ]]; then
        echo -e "${CYAN}---------------------------------------------${RESET}"
        echo -e "${CYAN}ID\tName\t\tDepartment\tCGPA${RESET}"
        echo -e "${CYAN}---------------------------------------------${RESET}"
        
        # Display the passed students
        for i in "${!passed_students[@]}"; do
            echo -e "${CYAN}${passed_students[$i]}\t${passed_names[$i]}\t\t${passed_departments[$i]}\t${passed_cgpas[$i]}${RESET}"
        done
        echo -e "Press Enter To Return To Main Menu..."
    read -r
    else
        echo -e "\n${BOLD_GREEN}No Passed Students Found!${RESET}"
        echo -e "Press Enter To Return To Main Menu..."
    read -r
    fi
}
############################################################################











#function to show all failed students whose cgpa < 2 ########################
failed_students()
{
    clear
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No Student Records Or Marks Found!${RESET}"
        return
    fi
    
    # Flag to check if any failed students are found
    local failed_found=0
    local failed_students=()
    local failed_names=()
    local failed_departments=()
    local failed_cgpas=()
    
    while IFS=',' read -r id sub1 sub2 sub3 grade1 grade2 grade3 cgpa || [[ -n "$id" ]]; do
        # Skip empty lines or records with N/A CGPA
        if [[ -z "$id" || "$cgpa" == "N/A" ]]; then
            continue
        fi
        
        # Check if student failed (CGPA < 2.0)
        if (( $(echo "$cgpa < 2.0" | bc -l) )); then
            student_info=$(grep "^$id," "$S_FILE")
            name=$(echo "$student_info" | cut -d',' -f2)
            department=$(echo "$student_info" | cut -d',' -f4)
            
            # Add failed student details to arrays
            failed_students+=("$id")
            failed_names+=("$name")
            failed_departments+=("$department")
            failed_cgpas+=("$cgpa")
            failed_found=1
        fi
    done < "$M_FILE"
    
    
    # Only show table if we found failed students
    if [[ $failed_found -eq 1 ]]; then
        echo -e "${CYAN}---------------------------------------------${RESET}"
        echo -e "${CYAN}ID\tName\t\tDepartment\tCGPA${RESET}"
        echo -e "${CYAN}---------------------------------------------${RESET}"
        
        # Display the failed students
        for i in "${!failed_students[@]}"; do
            echo -e "${CYAN}${failed_students[$i]}\t${failed_names[$i]}\t\t${failed_departments[$i]}\t${failed_cgpas[$i]}${RESET}"
        done
        echo -e "Press Enter To Return To Main Menu..."
    read -r
    else
        echo -e "\n${BOLD_GREEN}No Failed Students Found!${RESET}"
        echo -e "Press Enter To Return To Main Menu..."
    read -r
    fi
}
############################################################################







# Function to list students in ascending order of CGPA ######################
list_students_asc_cgpa()
{
    clear
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No Student Records Or Marks Found!${RESET}"
        return
    fi
    
    echo -e "${CYAN}--------------------------------------------${RESET}"
    echo -e "${CYAN}ID\tName\t\tDepartment\tCGPA${RESET}"
    echo -e "${CYAN}--------------------------------------------${RESET}"
    
    # Filter out entries with N/A CGPA
    grep -v ",N/A$" "$M_FILE" > temp_valid_cgpa.txt
    
    # Check if we have any valid CGPA entries
    if [[ ! -s temp_valid_cgpa.txt ]]; then
        echo -e "${BOLD_YELLOW}No Students With Valid CGPA Found!${RESET}"
        rm temp_valid_cgpa.txt
        echo -e "Press Enter To Return To Main Menu..."
        read -r
        return
    fi
    
    # Create a temporary file with sorted data (only entries with valid CGPA)
    sort -t',' -k8 -n temp_valid_cgpa.txt > temp_sort.txt
    
    while IFS=',' read -r id sub1 sub2 sub3 grade1 grade2 grade3 cgpa || [[ -n "$id" ]]; do
        # Skip empty lines
        if [[ -z "$id" ]]; then
            continue
        fi
        
        student_info=$(grep "^$id," "$S_FILE")
        name=$(echo "$student_info" | cut -d',' -f2)
        department=$(echo "$student_info" | cut -d',' -f4)
        
        echo -e "${CYAN}$id\t$name\t\t$department\t$cgpa${RESET}"
    done < temp_sort.txt
    
    # Remove temporary files
    rm temp_sort.txt temp_valid_cgpa.txt
    echo -e "Press Enter To Return To Main Menu..."
    read -r
}
##############################################################################








# Function to list students in descending order of CGPA ######################
list_students_desc_cgpa()
{
    clear
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No Student Records Or Marks Found!${RESET}"
        return
    fi
    echo -e "${CYAN}--------------------------------------------${RESET}"
    echo -e "${CYAN}ID\tName\t\tDepartment\tCGPA${RESET}"
    echo -e "${CYAN}--------------------------------------------${RESET}"
    
    # Filter out entries with N/A CGPA
    grep -v ",N/A$" "$M_FILE" > temp_valid_cgpa.txt
    
    # Check if we have any valid CGPA entries
    if [[ ! -s temp_valid_cgpa.txt ]]; then
        echo -e "${BOLD_YELLOW}No Students With Valid CGPA Found!${RESET}"
        rm temp_valid_cgpa.txt
        echo -e "Press Enter To Return To Main Menu..."
        read -r
        return
    fi
    
    # Create a temporary file with sorted data (only entries with valid CGPA)
    sort -t',' -k8 -nr temp_valid_cgpa.txt > temp_sort.txt
    
    while IFS=',' read -r id sub1 sub2 sub3 grade1 grade2 grade3 cgpa || [[ -n "$id" ]]; do
        # Skip empty lines
        if [[ -z "$id" ]]; then
            continue
        fi
        
        student_info=$(grep "^$id," "$S_FILE")
        name=$(echo "$student_info" | cut -d',' -f2)
        department=$(echo "$student_info" | cut -d',' -f4)
        
        echo -e "${CYAN}$id\t$name\t\t$department\t$cgpa${RESET}"
    done < temp_sort.txt
    
    # Remove temporary files
    rm temp_sort.txt temp_valid_cgpa.txt
    echo -e "Press Enter To Return To Main Menu..."
    read -r
}
###############################################################################







# Function to calculate grades for all students ##############################
calculate_grades() 
{
    clear
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No Student Records Or Marks Found!${RESET}"
        return
    fi
    
    
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
        name=$(echo "$student_info" | cut -d',' -f2)
        
        echo -e "${CYAN}Grades calculated for $name (ID: $id)${RESET}"
        sleep 0.5
    done < "$M_FILE"
    
    # Replace the original file with the updated one
    mv temp_marks.txt "$M_FILE"
    
    echo -e "${BOLD_GREEN}All Grades Have Been Calculated Successfully!${RESET}"
}
##############################################################################









# Function to calculate CGPA for all students ##############################
calculate_cgpa() 
{
    clear
    if [[ ! -f "$S_FILE" ]] || [[ ! -f "$M_FILE" ]]; then
        echo -e "${BOLD_YELLOW}No Student Records Or Marks Found!${RESET}"
        return
    fi
    
    
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
        name=$(echo "$student_info" | cut -d',' -f2)
        
        echo -e "${CYAN}CGPA Calculated For $name (ID: $id): $cgpa${RESET}"
        sleep 0.5
    done < "$M_FILE"
    
    # Replace the original file with the updated one
    mv temp_marks.txt "$M_FILE"
    
    echo -e "${BOLD_GREEN}All CGPAs Have Been Calculated Successfully!${RESET}"
}
##############################################################################