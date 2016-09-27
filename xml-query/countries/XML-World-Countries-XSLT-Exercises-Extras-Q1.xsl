<!-- in these exercises, you will be working with a small XML data set 
about world countries. This data is adapted from the Mondial 3.0 
database as hosted by the University of Washington, and was originally
compiled by the Georg-August University of Goettingen Institute for 
Informatics. Each country has a name, population, and area (in sq. km). 
Some countries also list languages (with percentages of the population 
that speaks each language) and/or cities (with names and populations). 
The XML data is "countries.xml". -->

<!-- Q1.Find all country names containing the string "stan"; return each 
one within a "Stan" element. (Note: To specify quotes within an already-quoted 
XPath expression, use quot;.)  -->
<?xml version="1.0" encoding="ISO-8859-1"?>
    <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template match="countries">
            <xsl:for-each select="country[contains(@name, 'stan')]">
                <Stan><xsl:value-of select="@name"/></Stan>
            </xsl:for-each>    
        </xsl:template>
        <xsl:template match="text()"/>
    </xsl:stylesheet>