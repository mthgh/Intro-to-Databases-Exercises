(: In these exercises, you will be working with a small XML data set :)
(: drawn from the Stanford course catalog. There are multiple departments,:) 
(: each with a department chair, some courses, and professors and/or :)
(: lecturers who teach courses. The XML file is "courses.xml" :)

(:Q1. Return all Title elements (of both departments and courses). :)
doc("courses.xml")//Title

(:Q2. Return last names of all department chairs. :)
doc("courses.xml")/Course_Catalog/Department/Chair/Professor/Last_Name

(:Q3. Return titles of courses with enrollment greater than 500.:)
doc("courses.xml")/Course_Catalog/Department/Course[@Enrollment>500]/Title

(:Q4. Return titles of departments that have some course that takes "CS106B" :)
(:as a prerequisite.:)
doc("courses.xml")/Course_Catalog/Department[Course/Prerequisites/Prereq='CS106B']/Title

(:Q5. Return last names of all professors or lecturers who use a middle initial. :)
(:Don't worry about eliminating duplicates.:)
doc("courses.xml")/Course_Catalog/Department//(Professor|Lecturer)[child::Middle_Initial]/Last_Name

(:Q6. Return the count of courses that have a cross-listed course (i.e., that have :)
(:"Cross-listed" in their description).:)
count(doc("courses.xml")/Course_Catalog/Department/Course[contains(Description, "Cross-listed")])

(:Q7. Return the average enrollment of all courses in the CS department.:)
avg(doc("courses.xml")/Course_Catalog/Department[@Code='CS']/Course/data(@Enrollment))

(:Q8. Return last names of instructors teaching at least one course that has "system" 
in its description and enrollment greater than 100.:)
doc("courses.xml")/Course_Catalog/Department/Course[contains(Description, "system") and @Enrollment>100]/
Instructors/(Professor|Lecturer)/Last_Name

(:Q9. Return the title of the course with the largest enrollment.:)
for $c in doc("courses.xml")/Course_Catalog/Department/Course
let $a := max(doc("courses.xml")/Course_Catalog/Department/Course/@Enrollment)
where $c/@Enrollment=$a
return $c/Title