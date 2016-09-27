<!-- In these exercises, you will be working with a small XML data set 
drawn from the Stanford course catalog. There are multiple departments, 
each with a department chair, some courses, and professors and/or 
lecturers who teach courses. The XML file is "courses.xml" -->

<!-- Q4.Create an HTML table with one-pixel border that lists all CS department 
courses with enrollment greater than 200. Each row should contain three cells: 
the course number in italics, course title in bold, and enrollment. Sort the 
rows alphabetically by course title. No header is needed. (Note: For formatting, 
just use "table border=1", and "<b>" and "<i>" tags for bold and italics respectively. 
To specify quotes within an already-quoted XPath expression, use quot;.)-->
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    exclude-result-prefixes="xs">
	
<xsl:template match="Course_Catalog/Department[@Code='CS']">
    <table border='1'>
        <xsl:for-each select="Course[@Enrollment>200]">
        <xsl:sort select="Title"/>
            <tr>
                <td><i><xsl:value-of select="@Number"/></i></td>
                <td><b><xsl:value-of select="Title"/></b></td>
                <td><xsl:value-of select="@Enrollment"/></td>
            </tr>
        </xsl:for-each>
    </table>