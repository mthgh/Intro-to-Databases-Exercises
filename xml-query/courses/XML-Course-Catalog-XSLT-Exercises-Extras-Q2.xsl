<!-- In these exercises, you will be working with a small XML data set 
drawn from the Stanford course catalog. There are multiple departments, 
each with a department chair, some courses, and professors and/or 
lecturers who teach courses. The XML file is "courses.xml" -->

<!-- Q2.Remove from the data all courses with enrollment greater than 60, or with no enrollment listed. 
Otherwise the structure of the data should be the same. -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="Course[@Enrollment>60]|Course[not(@Enrollment)]"/>
</xsl:stylesheet>