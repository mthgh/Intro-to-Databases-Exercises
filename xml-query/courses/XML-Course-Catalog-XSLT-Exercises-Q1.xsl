<!-- In these exercises, you will be working with a small XML data set 
drawn from the Stanford course catalog. There are multiple departments, 
each with a department chair, some courses, and professors and/or 
lecturers who teach courses. The XML file is "courses.xml" -->

<!-- Q1.Return a list of department titles. -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="Course_Catalog/Department/Title">
        <Title><xsl:value-of select="."/></Title>
    </xsl:template>
    <xsl:template match="text()"/>   
</xsl:stylesheet>
