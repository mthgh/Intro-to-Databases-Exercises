(: In these exercises, you will be working with a small XML data set about world countries. :)
(: This data is adapted from the Mondial 3.0 database as hosted by the University of Washington, :)
(: and was originally compiled by the Georg-August University of Goettingen Institute for Informatics. :)
(: Each country has a name, population, and area (in sq. km). Some countries also list languages :)
(: (with percentages of the population that speaks each language) and/or cities (with names and populations). :)
(: The XML data is "countries.xml" :)

(:Q1. Return the area of Mongolia.:)
doc("countries.xml")/countries/country[@name='Mongolia']/data(@area)

(:Q2. Return the names of all cities that have the same name as the country in which they are located.:)
doc("countries.xml")/countries/country/city[name=parent::country/@name]/name

(:Q3. Return the average population of Russian-speaking countries.:)
avg(doc("countries.xml")/countries/country[language='Russian']/data(@population))

(:Q4. Return the names of all countries that have at least three cities with population greater than 3 million. :)
doc("countries.xml")/countries/country[count(city[population>3000000])>=3]/data(@name)

(:Q5. Create a list of French-speaking and German-speaking countries. The result should take the form::)
(:<result>                                                             :)
(:  <French>                                                           :)
(:   <country>country-name</country>                                   :)
(:    <country>country-name</country>                                  :)
(:    ...                                                              :)
(:  </French>                                                          :)
(:  <German>                                                           :)
(:    <country>country-name</country>                                  :)
(:    <country>country-name</country>                                  :)
(:    ...                                                              :)
(:  </German>                                                          :)
(:</result>                                                            :)
<result>
    <French>
        {
        for $c in doc("countries.xml")/countries/country[language='French']
        return <country>
                   {$c/data(@name)}
               </country>
        }
    </French>
    <German>
        {
        for $c in doc("countries.xml")/countries/country[language='German']
        return <country>
                   {$c/data(@name)}
               </country>
        }
    </German>
</result>

(: Q6. Return the countries with the highest and lowest population densities. Note that because the "/" operator   :)
(: has its own meaning in XPath and XQuery, the division operator is infix "div". To compute population density use :)
(: "(@population div @area)". You can assume density values are unique. The result should take the form: :)
(: <result>                                               :)
(:   <highest density="value">country-name</highest>      :)
(:   <lowest density="value">country-name</lowest>        :)
(: </result>                                              :)
let $map := max(
             for $c in doc("countries.xml")/countries/country
             return ($c/@population div $c/@area)
             )
let $mip := min(
             for $c in doc("countries.xml")/countries/country
             return ($c/@population div $c/@area)
             )
let $mac := doc("countries.xml")/countries/country[./@population div ./@area=$map]
let $mic := doc("countries.xml")/countries/country[./@population div ./@area=$mip]
return 
      <result>
           <highest density="{$map}">
               {$mac/data(@name)}
           </highest>
           
           <lowest density="{$mip}">
               {$mic/data(@name)}
           </lowest>
      </result>