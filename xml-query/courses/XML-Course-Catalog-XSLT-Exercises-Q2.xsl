<!-- In these exercises, you will be working with a small XML data set 
drawn from the Stanford course catalog. There are multiple departments, 
each with a department chair, some courses, and professors and/or 
lecturers who teach courses. The XML file is "courses.xml" -->

<!-- Q2. Return a list of department elements with no attributes and two subelements each: 
the department title and the entire Chair subelement structure.  -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">      
    <xsl:template match="Department">
        <Department>
            <xsl:copy-of select="Chair|Title"/>
        </Department>
    </xsl:template>        
</xsl:stylesheet>
