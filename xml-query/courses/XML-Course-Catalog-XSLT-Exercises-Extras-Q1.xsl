<!-- In these exercises, you will be working with a small XML data set 
drawn from the Stanford course catalog. There are multiple departments, 
each with a department chair, some courses, and professors and/or 
lecturers who teach courses. The XML file is "courses.xml" -->

<!-- Q1.Return all courses with enrollment greater than 500. Retain the 
structure of Course elements from the original data.  -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="Course[@Enrollment>500]">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="text()"/>        
</xsl:stylesheet>