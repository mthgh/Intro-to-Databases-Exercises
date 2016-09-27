(: In these exercises, you will be working with a small XML data set :)
(: drawn from the Stanford course catalog. There are multiple departments,:) 
(: each with a department chair, some courses, and professors and/or :)
(: lecturers who teach courses. The XML file is "courses.xml" :)

(:Q1. Return the course number of the course that is cross-listed as "LING180". :)
doc("courses.xml")/Course_Catalog/Department/Course[contains(Description,'LING180')]/data(@Number)

(:Q2. Return course numbers of courses that have the same title as some other course. (Hint: You might :)
(:want to use the "preceding" and "following" navigation axes for this query, which were not covered in :)
(:the video or our demo script; they match any preceding or following node, not just siblings.) :)
for $c1 in doc("courses.xml")/Course_Catalog/Department/Course
for $c2 in doc("courses.xml")/Course_Catalog/Department/Course
where $c1/@Number!=$c2/@Number and $c1/Title=$c2/Title
return $c1/data(@Number)

(:Q3. Return course numbers of courses taught by an instructor with first name "Daphne" or "Julie".:)
doc("courses.xml")/Course_Catalog/Department/Course[Instructors/(Professor|Lecturer)/First_Name='Daphne' or
                                                    Instructors/(Professor|Lecturer)/First_Name='Julie']/data(@Number)

(:Q4. Return the number (count) of courses that have no lecturers as instructors.:)
count(doc("courses.xml")/Course_Catalog/Department/Course[not(Instructors/Lecturer)])

(:Q5. Return titles of courses taught by the chair of a department. For this question, you may assume that :)
(:all professors have distinct last names.:)
for $c in doc("courses.xml")/Course_Catalog/Department/Course
let $dc := $c/../Chair/Professor/Last_Name
let $ci := $c/Instructors/(Professor|Lecturer)/Last_Name
where $dc = $ci
return $c/Title

(:Q6. Return titles of courses that have both a lecturer and a professor as instructors. :)
(:Return each title only once. :)
doc("courses.xml")/Course_Catalog/Department/Course[Instructors/Professor and 
                                                    Instructors/Lecturer]/Title

(:Q7. Return titles of courses taught by a professor with the last name "Ng" but not by :)
(:a professor with the last name "Thrun".:)
doc("courses.xml")/Course_Catalog/Department/Course[Instructors/Professor/Last_Name="Ng"
                                           and not(Instructors/Professor/Last_Name="Thrun")]/Title

(:Q8. Return course numbers of courses that have a course taught by Eric Roberts as a prerequisite. :)
for $c in  doc("courses.xml")/Course_Catalog/Department/Course
let $pre := $c/Prerequisites/Prereq
let $p := doc("courses.xml")/Course_Catalog/Department/Course[@Number=$pre]/Instructors/(Professor|Lecturer)
where $p/Last_Name='Roberts' and $p/First_Name='Eric'
return data($c/@Number)

(:Q9.Create a summary of CS classes: List all CS department courses in order of enrollment. For each course 
include only its Enrollment (as an attribute) and its Title (as a subelement). :)
<Summary>
    {
	for $c in doc("courses.xml")/Course_Catalog/Department[@Code='CS']/Course
	order by xs:int($c/@Enrollment)
	return <Course>
	            {$c/@Enrollment} {$c/Title}     
	       </Course>
    }
</Summary>

(: Q10. Return a "Professors" element that contains as subelements a listing of all professors in all :)
(: departments, sorted by last name with each professor appearing once. The "Professor" subelements :)
(: should have the same structure as in the original data. For this question, you may assume that all :)
(: professors have distinct last names. Watch out -- the presence/absence of middle initials may require :)
(: some special handling. (This problem is quite challenging; congratulations if you get it right.) :)
<Professors>
    {
    for $ln in distinct-values(doc("courses.xml")//Professor/Last_Name)
    let $p := (doc("courses.xml")/Course_Catalog/Department//Professor[Last_Name=$ln])[1]
    order by $ln
    return <Professor>
                {$p/First_Name}
                {$p/Middle_Initial}
                {$p/Last_Name}
           </Professor>
    }
</Professors>

(: Q11. Expanding on the previous question, create an inverted course listing: Return an "Inverted_Course_Catalog" :)
(: element that contains as subelements professors together with the courses they teach, sorted by last name. You :)
(: may still assume that all professors have distinct last names. The "Professor" subelements should have the same :)
(: structure as in the original data, with an additional single "Courses" subelement under Professor, containing a :)
(: further "Course" subelement for each course number taught by that professor. Professors who do not teach any :)
(: courses should have no Courses subelement at all. (This problem is very challenging; extra congratulations if you :)
(: get it right.) :)
<Inverted_Course_Catalog>
    {
    for $ln in distinct-values(doc("courses.xml")//Professor/Last_Name)
    let $p := (doc("courses.xml")/Course_Catalog/Department//Professor[Last_Name=$ln])[1]
    order by $ln
    return <Professor>
                {$p/First_Name}
                {$p/Middle_Initial}
                {$p/Last_Name}
                {
                let $c := doc("courses.xml")/Course_Catalog/Department/Course[Instructors/Professor/Last_Name=$ln]
                return
                    if ($c)
                    then 
                      <Courses>
                          {
                          for $cc in $c
                          return 
                              <Course>
                                 {data($cc/@Number)}
                              </Course>
                          }
                      </Courses>
                    else ()
                }
           </Professor>
    }
</Inverted_Course_Catalog>