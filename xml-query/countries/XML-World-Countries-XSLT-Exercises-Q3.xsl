<!-- in these exercises, you will be working with a small XML data set 
about world countries. This data is adapted from the Mondial 3.0 
database as hosted by the University of Washington, and was originally
compiled by the Georg-August University of Goettingen Institute for 
Informatics. Each country has a name, population, and area (in sq. km). 
Some countries also list languages (with percentages of the population 
that speaks each language) and/or cities (with names and populations). 
The XML data is "countries.xml". -->

<!-- Q3. Create an alternate version of the countries database: for each 
country, include its name and population as sublements, and the number of 
languages and number of cities as attributes (called "languages" and 
"cities" respectively).-->
<?xml version="1.0" encoding="ISO-8859-1"?>
    <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template match="countries">
            <countries>
                <xsl:for-each select="country">
                    <country>
                        <xsl:attribute name="languages"><xsl:value-of select="count(language)"/></xsl:attribute>
                        <xsl:attribute name="cities"><xsl:value-of select="count(city)"/></xsl:attribute>
                            <name>
						        <xsl:value-of select="@name"/>
							</name>
                            <population>
							    <xsl:value-of select="@population"/>
							</population>
                    </country>
                </xsl:for-each>
            </countries>
        </xsl:template>
        <xsl:template match="text()"/>
    </xsl:stylesheet>