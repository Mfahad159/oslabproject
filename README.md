# Student Management System

A comprehensive Bash-based command-line Student Management System that allows teachers to manage student records, assign marks, calculate grades and CGPA, while providing students access to view their academic performance.

## Features

### Teacher Portal

- User authentication with secure login
- Add and delete student records
- Assign marks for subjects (OS, DB, PROB)
- Calculate letter grades based on marks
- Calculate CGPA based on letter grades
- View students sorted by CGPA (ascending/descending)
- View lists of passed and failed students

### Student Portal

- Individual student authentication
- View personal grades for all subjects
- View personal CGPA with performance status

## File Structure

- `main.sh`: Main entry point and authentication handler
- `teacher.sh`: Functions for teacher operations
- `student.sh`: Functions for student operations
- `students.txt`: Student personal information storage
- `auth.txt`: Authentication credentials storage
- `marks.txt`: Academic performance data storage

## System Requirements

- Linux/Unix-based operating system
- Bash shell (version 4.0 or higher)
- Basic command-line utilities (bc, grep, sed)

## Installation

1. Clone or download the repository:

   ```
   git clone https://github.com/yourusername/oslabproject.git
   ```

2. Navigate to the project directory:

   ```
   cd oslabproject
   ```

3. Make the scripts executable:
   ```
   chmod +x main.sh teacher.sh student.sh
   ```

## Usage

1. Start the application:

   ```
   ./main.sh
   ```

2. Follow the on-screen menu to:
   - Access the Teacher Portal (username: admin, password: 123)
   - Access the Student Portal (using student ID and password)
   - View credits
   - Exit the system

### Teacher Operations

- Add students with personal details
- Delete students and their records
- Assign marks for three subjects
- Calculate letter grades and CGPA
- Generate various performance reports

### Student Operations

- View personal grades for all subjects
- View personal CGPA with performance status

## Data Format

### Students File (students.txt)

```
student_id,name,age,department
```

### Authentication File (auth.txt)

```
student_id,password
```

### Marks File (marks.txt)

```
student_id,OS_marks,DB_marks,PROB_marks,OS_grade,DB_grade,PROB_grade,CGPA
```

## Credits

Developed by Muhammad Fahad (23F-0696) & Ajmal Razaq (23F-0524)
