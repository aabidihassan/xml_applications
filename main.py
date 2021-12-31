import sys
import lxml.etree as etree
from bs4 import BeautifulSoup

xmlShemaFile = 'static\\convertion\\project\\xsdFile.xsd'  # input xml schema
newXmlShema = 'static\\convertion\\project\\newXmlShema.xsd'  # le fichier dans lequelle on va met le xsd apres la suppression du 'xs:' et 'xsd:'
DllXSLTFile = 'static\\convertion\\project\\program.xslt'  # le programme xslt
HTMLFile = 'static\\convertion\\project\\result.html'  # la resultas du transformation xslt en format html
SqlScript = 'static\\convertion\\project\\result.sql'  # le fichier dans lequel on va met le contenue on format txt (deduit a partir du fichier html utilisant 'BeautifulSoup'
XmlFile = 'static\\convertion\\project\\xmlFile.xml'
EditedXmlFile = 'static\\convertion\\project\\editedXmlFile.xml'
DDL = 'static\\convertion\\project\\DDL.sql'
DML = 'static\\convertion\\project\\DML.sql'
DmlXSLTFile = 'static\\convertion\\project\\dml.xslt'  # le programme xslt


def conertionTotal():
    try:
        # Read in the file
        with open(xmlShemaFile, 'r') as file:
            filedata = file.read()

        # Replace the target string
        if "xsd:" in filedata:
            filedata = filedata.replace('xsd:', '')

        elif "xs:" in filedata:
            filedata = filedata.replace('xs:', '')

        # Write the file out again
        with open(newXmlShema, 'w') as file:
            file.write(filedata)


        xml = etree.parse(open(XmlFile, 'r'))
        rootTag = xml.getroot().tag
        tagElement = "<RootElementTag>" + rootTag + "</RootElementTag>"
        xsdRoot = etree.parse(open(newXmlShema, 'r')).getroot()
        xmlElement = etree.fromstring(tagElement)
        xsdRoot.append(xmlElement)
        with open(newXmlShema, 'w') as file:
            original_stdout = sys.stdout
            sys.stdout = file
            print(etree.tostring(xsdRoot, pretty_print=True, encoding='unicode'))
            sys.stdout = original_stdout

        data = open(DllXSLTFile)
        xslt_content = data.read()
        xslt_root = etree.XML(xslt_content)
        dom = etree.parse(newXmlShema)
        transform = etree.XSLT(xslt_root)
        result = transform(dom)
        f = open(HTMLFile, 'w')
        f.write(str(result))
        f.close()

        with open(HTMLFile, 'r') as file:
            result = file.read().replace("<br/>", '\n')
            ddlXml = etree.fromstring(result)
            ddlTree = ddlXml.xpath('//ddl')[0]  # get ddl root to write it in DDL file
            dmlTree = ddlXml.xpath('//dml')[0]  # get dml root to write it in XML file
            with open(XmlFile, 'r') as file2:
                xmlData = etree.parse(file2)
                # adding the dml tree to the XML File
                xmlRoot = xmlData.getroot()
                xmlRoot.append(dmlTree)
                with open(EditedXmlFile, 'w') as file3:
                    sys.stdout = file3
                    print(etree.tostring(xmlRoot, pretty_print=True, encoding='unicode'))
                    sys.stdout = original_stdout
                # end

            # writing ddl tree to the file
            with open(DDL, 'w') as file2:
                sys.stdout = file2
                print(etree.tostring(ddlTree, pretty_print=True, encoding='unicode'))
                sys.stdout = original_stdout
                # replace xml ddl tag with whitespace
            with open(DDL, 'r') as file2:
                filedata = file2.read()
                ddl_contend = filedata.replace("<ddl>", '')
                ddl_contend = ddl_contend.replace("</ddl>", '')
                with open(DDL, 'w') as file3:
                    file3.write(ddl_contend)
                # end
            # end

        data = open(DmlXSLTFile)
        xslt_content = data.read()
        xslt_root = etree.XML(xslt_content)
        dom = etree.parse(EditedXmlFile)
        transform = etree.XSLT(xslt_root)
        result = transform(dom)
        f = open(DML, 'w')
        f.write(str(result))
        f.close()
        with open(DML, 'r') as file:
            result = file.read().replace("<?xml version=\"1.0\"?>", '')
            f = open(DML, 'w')
            f.write(str(result))
            f.close()
        return "all"

    except Exception as e:
        return False
