############# helper function ####################################
from lxml import etree
def dtd_validation(xml_file, dtd_file):
    dtd = etree.DTD(open(dtd_file))
    root = etree.parse(xml_file)
    if dtd.validate(root):
        print "Validation Succeeded"
    else:
        print "Validation Failed"
##################################################################

############### change working directory #########################
import os
cwd = os.getcwd()
file_dir = os.path.join(os.path.dirname(cwd),'xml-validation')
os.chdir(file_dir)
##################################################################


"""Instructions: For each question, you are to write a DTD that validates against the corresponding XML data set."""

# Q1:
# In this question, you are to create a DTD for a small XML data set drawn from the Stanford course catalog. 
# There are multiple departments, each with a department chair, some courses, and professors and/or lecturers
# who teach courses. The XML data is "courses-noID.xml". 
# Important: Do not include <!DOCTYPE Course_Catalog [...]> in your DTD. Your DTD should start with 
# <!ELEMENT Course_Catalog (Department*)>. 

# A1: see "courses-noID-dtd.dtd", below is the validation.
print "Q1:"
dtd_validation("courses-noID.xml", "courses-noID-dtd.dtd")

# Q2:
# In this question, you are to create a DTD for a different version of the data set drawn from the Stanford course catalog. 
# This version encodes the data using ID and IDREF(S) attributes. The XML data is "courses-ID.xml". 
# Hint: You may want to use your DTD from the previous question as a starting point, since the structure is similar. 
# Important: Do not include <!DOCTYPE Course_Catalog [...]> in your DTD. Your DTD should start with 
# <!ELEMENT Course_Catalog (Department*)>.

# A2: see "courses-ID-dtd.dtd", below is the validation.
print "Q2:"
dtd_validation("courses-ID.xml", "courses-ID-dtd.dtd")

# Q3:
# In this question, you are to create a DTD for a small XML data set about world countries. 
# This data is adapted from the Mondial 3.0 database as hosted by the University of Washington, 
# and was originally compiled by the Georg-August University of Goettingen Institute for Informatics. 
# Each country has a name, population, and area (in sq. km). Some countries also list languages 
# (with percentages of the population that speaks each language) and/or cities (with names and populations). 
# The XML data is "countries.xml". 
# Important: Do not include <!DOCTYPE countries [...]> in your DTD. Your DTD should start with 
# <!ELEMENT countries (country*)>.

# A2: see "countries-dtd.dtd", below is the validation.
print "Q3:"
dtd_validation("countries.xml", "countries-dtd.dtd")

############ change working directory back ######################################
os.chdir(cwd)
