<!-- in these exercises, you will be working with a small XML data set 
about world countries. This data is adapted from the Mondial 3.0 
database as hosted by the University of Washington, and was originally
compiled by the Georg-August University of Goettingen Institute for 
Informatics. Each country has a name, population, and area (in sq. km). 
Some countries also list languages (with percentages of the population 
that speaks each language) and/or cities (with names and populations). 
The XML data is "countries.xml". -->

<!-- Q2.Create a table using HTML constructs that lists all countries 
that have more than 3 languages. Each row should contain the country name 
in bold, population, area, and number of languages. Sort the rows in descending
order of number of languages. No header is needed for the table, but use 
<table border="1"> to make it format nicely, should you choose to check your 
result in a browser. (Hint: You may find the data-type and order attributes 
of <xsl:sort> to be useful.)  -->
<?xml version="1.0" encoding="ISO-8859-1"?>
    <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template match="countries">
            <html>
                <table border='1'>
                    <xsl:for-each select="country[count(language) &gt; 3]">
                    <xsl:sort select="-count(language)"/>
                        <tr>
                            <td><b><xsl:value-of select="@name"/></b></td>
                            <td><xsl:value-of select="@population"/></td>
                            <td><xsl:value-of select="@area"/></td>
                            <td><xsl:value-of select="count(language)"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </html>
        </xsl:template>
        <xsl:template match="text()"/>
    </xsl:stylesheet>