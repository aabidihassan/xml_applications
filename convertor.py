import lxml.etree as etree
from bs4 import BeautifulSoup

def convertor(xmlShemaFile):
    try:
        with open(xmlShemaFile, 'r') as file:
            filedata = file.read()

        # Replace the target string
        if "xsd:" in filedata:
            filedata = filedata.replace('xsd:', '')

        elif "xs:" in filedata:
            filedata = filedata.replace('xs:', '')

        # Write the file out again
        with open("static/convertion/xsdfiles/newXmlShema.xsd", 'w') as file:
            file.write(filedata)

        with open("static/convertion/xslt/program.xslt", 'r') as file:
            xslt_content = file.read()

        xslt_root = etree.XML(xslt_content)
        dom = etree.parse("static/convertion/xsdfiles/newXmlShema.xsd")
        transform = etree.XSLT(xslt_root)
        result = transform(dom)
        f = open("static/convertion/html/result.html", 'w')
        f.write(str(result))
        f.close()

        with open("static/convertion/html/result.html", 'r') as file:
            htmlContent = file.read()
            soup = BeautifulSoup(htmlContent, 'lxml')
            ScriptFile = open("static/convertion/sql/result.sql", 'w')
            ScriptFile.write(soup.get_text())
            ScriptFile.close()
        return True
    except Exception as e:
        return False

