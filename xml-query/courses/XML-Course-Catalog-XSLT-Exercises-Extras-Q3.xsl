<!-- In these exercises, you will be working with a small XML data set 
drawn from the Stanford course catalog. There are multiple departments, 
each with a department chair, some courses, and professors and/or 
lecturers who teach courses. The XML file is "courses.xml" -->

<!-- Q3.Create a summarized version of the EE part of the course catalog. 
For each course in EE, return a Course element, with its Number and Title as attributes, 
its Description as a subelement, and the last name of each instructor as an Instructor subelement. 
Discard all information about department titles, chairs, enrollment, and prerequisites, as well as all 
courses in departments other than EE. (Note: To specify quotes within an already-quoted XPath expression, use quot;.) -->
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    exclude-result-prefixes="xs">

    <xsl:template match="Department[@Code='EE']">
        <xsl:for-each select="Course">
            <Course>
                <xsl:attribute name="Number"><xsl:value-of select="@Number"/></xsl:attribute>
                <xsl:attribute name="Title"><xsl:value-of select="Title"/></xsl:attribute>
                <xsl:copy-of select="Description"/>
                <xsl:for-each select="Instructors/Professor|Lecturer">
                    <Instructor>
                        <xsl:value-of select="Last_Name"/>
                    </Instructor>
                </xsl:for-each>
            </Course>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="text()"/>  
	
</xsl:stylesheet>