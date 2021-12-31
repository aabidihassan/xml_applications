from flask import Flask, request, jsonify, send_file, send_from_directory
from flask.templating import render_template
from lxml import etree
import os
import xmlschema
from convertor import convertor as conv
from main import conertionTotal as convtotal

app = Flask(__name__)


@app.route('/')
def index():  # put application's code here
    return render_template('index.html')

@app.route('/validator', methods=['POST'])
def validator():
    try:
        xmlFile = request.files['xmlFile']
        validatorFile = request.files.get('validatorFile', None)
        if validatorFile is None:
            return internalDtd(xmlFile)
        else:
            return externalvalidation(xmlFile, validatorFile)
    except Exception as e:
        return jsonify(result="invalide")

@app.route('/convertor', methods=['GET', 'POST'])
def convertor():
    if request.method == 'GET':
        return render_template('convertor.html')
    else :
        try:
            xsdFile = request.files.get('xsdFile', None)
            xmlFile = request.files.get('xmlFile', None)
            xsdFile.save(os.path.join("static/convertion/project", "xsdFile.xsd"))
            if xmlFile is None:
                res = conv("static\\convertion\\project\\xsdFile.xsd")

            else:
                xmlFile.save(os.path.join("static/convertion/project", "xmlFile.xml"))
                res = convtotal()

            return jsonify(result = res)
        except Exception as e:
            return jsonify(result = False)


def externalDtd(xmlFile , dtdFile):
    dtd = etree.DTD(dtdFile)
    tree = etree.parse(xmlFile)
    root = tree.getroot()
    status = dtd.validate(root)
    return jsonify(result=status)

def internalDtd(xmlFile):
    tree = etree.parse(xmlFile)
    dtd = tree.docinfo.internalDTD
    root = tree.getroot()
    status = dtd.validate(root)
    return jsonify(result=status)

def xsdValidation(xmlFile, xsdFile):
    XS = xmlschema.XMLSchema(xsdFile)
    status = XS.is_valid(xmlFile)
    return jsonify(result=status)

def externalvalidation(xmlFile , validatorFile):
    extension = validatorFile.filename.rsplit('.', 1)[1].lower()
    if extension == 'xsd':
        return xsdValidation(xmlFile, validatorFile)
    else:
        return externalDtd(xmlFile, validatorFile)


if __name__ == '__main__':
    app.run()
