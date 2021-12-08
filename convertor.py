import lxml.etree as etree
from bs4 import BeautifulSoup

#xmlShemaFile = 'static\\XML Project\\test.xsd' # input xml schema


def convertor(xmlShemaFile):
    newXmlShema = 'C:\\Users\\hassa\\Desktop\\M1 ISI\\Traitement de documents  ́electroniques\\Projet\\back\\static\\new_xsd.xsd'  # le fichier dans lequelle on va met le xsd apres la suppression du 'xs:' et 'xsd:'
    XSLTFile = 'C:\\Users\\hassa\\Desktop\\M1 ISI\\Traitement de documents  ́electroniques\\Projet\\back\\static\\XML Project\\program.xslt'  # le programme xslt
    HTMLFile = 'C:\\Users\\hassa\\Desktop\\M1 ISI\\Traitement de documents  ́electroniques\\Projet\\back\\static\\XML Project\\result.html'  # la resultas du transformation xslt en format html
    SqlScript = 'C:\\Users\\hassa\\Desktop\\M1 ISI\\Traitement de documents  ́electroniques\\Projet\\back\\static\\XML Project\\result.sql'  # le fichier dans lequel on va met le contenue on format txt (deduit a partir du fichier html utilisant 'BeautifulSoup'

    print("Let's go")
    #Read in the file
    # with open(xmlShemaFile, 'r') as file:
    #     filedata = file.read()
    filedata = xmlShemaFile

    print("I read the xsd")

    # Replace the target string
    if "xsd:" in filedata:
        filedata = filedata.replace('xsd:', '')

    elif "xs:" in filedata:
        filedata = filedata.replace('xs:', '')

    print("I Replace the target string")

    # Write the file out again
    with open(newXmlShema, 'w') as file:
        file.write(filedata)

    print("I Write the file out again")

    data = open(XSLTFile)
    xslt_content = data.read()
    xslt_root = etree.XML(xslt_content)
    dom = etree.parse(newXmlShema)
    transform = etree.XSLT(xslt_root)
    result = transform(dom)
    f = open(HTMLFile, 'w')
    f.write(str(result))
    f.close()
    with open(HTMLFile, 'r') as file:
        htmlContent = file.read()
        soup = BeautifulSoup(htmlContent, 'lxml')
        print(soup.get_text())
        ScriptFile = open(SqlScript, 'w')
        ScriptFile.write(soup.get_text())
        ScriptFile.close()
    return SqlScript

