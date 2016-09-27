<!-- in these exercises, you will be working with a small XML data set 
about world countries. This data is adapted from the Mondial 3.0 
database as hosted by the University of Washington, and was originally
compiled by the Georg-August University of Goettingen Institute for 
Informatics. Each country has a name, population, and area (in sq. km). 
Some countries also list languages (with percentages of the population 
that speaks each language) and/or cities (with names and populations). 
The XML data is "countries.xml". -->

<!-- Q2. Remove from the data all countries with area greater than 40,000 
and all countries with no cities listed. Otherwise the structure of the 
data should be the same.  -->
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>   
    <xsl:template match="countries/country[@area>40000]"/>
    <xsl:template match="countries/country[not(city)]"/>
</xsl:stylesheet>