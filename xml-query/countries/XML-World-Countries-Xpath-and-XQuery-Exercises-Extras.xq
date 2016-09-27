(: In these exercises, you will be working with a small XML data set about world countries. :)
(: This data is adapted from the Mondial 3.0 database as hosted by the University of Washington, :)
(: and was originally compiled by the Georg-August University of Goettingen Institute for Informatics. :)
(: Each country has a name, population, and area (in sq. km). Some countries also list languages :)
(: (with percentages of the population that speaks each language) and/or cities (with names and populations). :)
(: The XML data is "countries.xml" :)

(:Q1. Return the names of all countries with population greater than 100 million.:)
doc("countries.xml")/countries/country[@population>100000000]/data(@name)

(:Q2. Return the names of all countries where over 50% of the population speaks German. (Hint: Depending on your :)
(:solution, you may want to use ".", which refers to the "current element" within an XPath expression.) :)
for $c in doc("countries.xml")/countries/country
where $c/language[@percentage>50  and .='German']
return $c/data(@name)

(:Q3. Return the names of all countries where a city in that country contains more than one-third of the country's :)
(: population. :)
doc("countries.xml")/countries/country[(city/population>(1 div 3) * @population)]/data(@name)

(:Q4. Return the population density of Qatar. Note: Since the "/" operator has its own meaning in XPath and XQuery, :)
(: the division operator is "div". To compute population density use "(@population div @area)". :)
for $c in doc("countries.xml")/countries/country
where $c/@name='Qatar'
return $c/@population div $c/@area

(:Q5. Return the names of all countries whose population is less than one thousandth that of some city (in any country). :)
doc("countries.xml")/countries/country
[@population * 1000 <doc("countries.xml")/countries/country/city/population]/data(@name)

(:Q6. Return all city names that appear more than once, i.e., there is more than one city with that name in the data. :)
(:Return only one instance of each such city name. (Hint: You might want to use the "preceding" and/or "following" :)
(:navigation axes for this query, which were not covered in the video or our demo script; they match any preceding :)
(:or following node, not just siblings.) :)
for $discn in distinct-values(doc("countries.xml")/countries/country/city/name)
let $cn := (doc("countries.xml")/countries/country/city[name=$discn]/name)[1]
for $cn1 in doc("countries.xml")/countries/country/city/name
where $cn=$cn1 and $cn/..!=$cn1/..
return $cn

(:Q7. Return the names of all countries containing a city such that some other country has a city of the same name. :)
(:(Hint: You might want to use the "preceding" and/or "following" navigation axes for this query, which were not :)
(:covered in the video or our demo script; they match any preceding or following node, not just siblings.) :)
doc("countries.xml")/countries/country[city/name=preceding::name or city/name=following::name]/data(@name)

(:Q8.Return the names of all countries whose name textually contains a language spoken in that country. For instance, :)
(:Uzbek is spoken in Uzbekistan, so return Uzbekistan. (Hint: You may want to use ".", which refers to the "current :)
(:element" within an XPath expression.) 
for $cy in doc("countries.xml")/countries/country
for $lan in $cy/language
return $cy[contains(@name, $lan)]/data(@name)

(:Q9.Return the names of all countries in which people speak a language whose name textually contains the name of the country.:) 
(:For instance, Japanese is spoken in Japan, so return Japan. (Hint: You may want to use ".", which refers to the "current :)
(:element" within an XPath expression.) :)
for $cy in doc("countries.xml")/countries/country
for $lan in $cy/language
return $cy[contains($lan, @name)]/data(@name)

(:Q10.Return all languages spoken in a country whose name textually contains the language name. For instance, German is spoken :)
(: in Germany, so return German. (Hint: Depending on your solution, may want to use data(.), which returns the text value of the :)
(: "current element" within an XPath expression.) :)
for $cy in doc("countries.xml")/countries/country
for $lan in distinct-values($cy/language)
where contains($cy/@name, $lan)
return $lan

(:Q11.Return all languages whose name textually contains the name of a country in which the language is spoken. For instance, :)
(:Icelandic is spoken in Iceland, so return Icelandic. (Hint: Depending on your solution, may want to use data(.), which :)
(:returns the text value of the "current element" within an XPath expression.) :)
for $cy in doc("countries.xml")/countries/country
for $lan in distinct-values($cy/language)
where contains($lan, $cy/@name)
return $lan

(:Q12.Return the number of countries where Russian is spoken. :)
count(doc("countries.xml")/countries/country[language='Russian'])

(:Q13. Return the names of all countries for which the data does not include any languages or cities, but the country has :)
(:more than 10 million people. :)
doc("countries.xml")/countries/country[@population>10000000
                                      and count(language)=0 
								      and count(city)=0]/data(@name)

(:Q14.Return the name of the country with the highest population. (Hint: You may need to explicitly cast population numbers :)
(:as integers with xs:int() to get the correct answer.) :)
for $cy in doc("countries.xml")/countries/country
where $cy/@population=max(
                         for $popu in doc("countries.xml")/countries/country/@population
						 return xs:int($popu)
						 )
return $cy/data(@name)

(:Q15.Return the name of the country that has the city with the highest population. (Hint: You may need to explicitly cast :)
(:population numbers as integers with xs:int() to get the correct answer.) :)
for $cy in doc("countries.xml")/countries/country
where $cy/city/population= max(
                              for $popu in doc("countries.xml")/countries/country/city/population
							  return xs:int($popu)
							  )
return $cy/data(@name)

(:Q16.Return the average number of languages spoken in countries where Russian is spoken. :)
count(doc("countries.xml")/countries/country[language="Russian"]/language) div 
count(doc("countries.xml")/countries/country[language="Russian"])

(:Q17.Return all country-language pairs where the language is spoken in the country and the name of the country textually :)
(:contains the language name. Return each pair as a country element with language attribute, e.g.,  :)
(:<country language="French">French Guiana</country> :)
for $cy in doc("countries.xml")/countries/country
for $lan in distinct-values($cy/language)
where contains($cy/@name, $lan)
return
<country language="{$lan}">

{$cy/data(@name)}

</country>

(:Q18.Return all countries that have at least one city with population greater than 7 million. For each one, return the :)
(:country name along with the cities greater than 7 million, in the format: :)
(:<country name="country-name"> :)
(:  <big>city-name</big>        :)
(:  <big>city-name</big>        :)
(:  ...                         :)
(:</country>                    :)
for $cy in doc("countries.xml")/countries/country[city/population>7000000]
let $ci:=$cy/city[population>7000000]
return
<country> {$cy/@name}
    {for $ci_each in $ci 
     return 
        <big>
           {$ci_each/data(name)}
        </big>}
</country>

(:Q19.Return all countries where at least one language is listed, but the total percentage for all listed languages is less than :)
(:90%. Return the country element with its name attribute and its language subelements, but no other attributes or subelements. :)
for $cy in doc("countries.xml")/countries/country[language]
let $lan:=$cy/language
where  sum(
           for $lan_each in $lan
           return $lan_each/data(@percentage)
           ) < 90
return
    <country>
        {$cy/@name} {$lan}
    </country>

(:Q20.Return all countries where at least one language is listed, and every listed language is spoken by less than 20% of the :)
(:population. Return the country element with its name attribute and its language subelements, but no other attributes or :)
(:subelements. :)
for $cy in doc("countries.xml")/countries/country[language]
let $lan:=$cy/language
where count(
           for $lan_each in $lan
           where $lan_each/data(@percentage<20)
           return $lan_each) 
       = 
       count(
            for $lan_each in $lan
            return $lan_each)
return
    <country>
        {$cy/@name} {$lan}
    </country>
	
(:Q21.Find all situations where one country's most popular language is another country's least popular, and both countries :)
(:list more than one language. (Hint: You may need to explicitly cast percentages as floating-point numbers with xs:float()  :)
(:to get the correct answer.) Return the name of the language and the two countries, each in the format: :)
(:<LangPair language="lang-name">              :)
(:  <MostPopular>country-name</MostPopular>    :)
(:  <LeastPopular>country-name</LeastPopular>  :)
(:</LangPair>                                  :)
for $cy1 in doc("countries.xml")/countries/country[count(language)>1]
for $cy2 in doc("countries.xml")/countries/country[count(language)>1]
let $lan1:=$cy1/language
let $lan2:=$cy2/language
let $max:=max(
              for $lan_each in $lan1
              return $lan_each/xs:float(data(@percentage))
              )
let $min:=min(
              for $lan_each in $lan2
              return $lan_each/xs:float(data(@percentage))
              )
let $lanpair:=(
               for $lan_each_1 in $lan1
               for $lan_each_2 in $lan2
               where $lan_each_1=$lan_each_2 and 
               $lan_each_1/xs:float(data(@percentage))=$max and 
               $lan_each_2/xs:float(data(@percentage))=$min
               return $lan_each_1
               )
where $cy1!=$cy2 and $lanpair
return 
    <LangPair language="{data($lanpair)}">
        <MostPopular>{$cy1/data(@name)}</MostPopular>
        <LeastPopular>{$cy2/data(@name)}</LeastPopular>
    </LangPair>
	
(: Q22.For each language spoken in one or more countries, create a "language" element with a "name" attribute and one    :)
(: "country" subelement for each country in which the language is spoken. The "country" subelements should have two      :)
(: attributes: the country "name", and "speakers" containing the number of speakers of that language (based on language   :)
(: percentage and the country's population). Order the result by language name, and enclose the entire list in a single   :)
(: "languages" element. For example, your result might look like: :)
(: <languages>                                                    :)
(:   ...                                                          :)
(:   <language name="Arabic">                                     :)
(:     <country name="Iran" speakers="660942"/>                   :)
(:     <country name="Saudi Arabia" speakers="19409058"/>         :)
(:     <country name="Yemen" speakers="13483178"/>                :)
(:   </language>                                                  :)
(:   ...                                                          :)
(: </languages>                                                   :)
<languages>
    {
    for $lan in distinct-values(doc("countries.xml")/countries/country/language)
    order by $lan
    return
    <language name="{$lan}">{
                             for $cy in doc("countries.xml")/countries/country
                             where $cy/language=$lan
                             return 
                                   <country name="{$cy/data(@name)}" 
                                            speakers="{xs:int($cy/language[.=$lan]/@percentage * $cy/@population * 0.01)}">
  
                                   </country>
                             }
     </language>
    }
</languages>