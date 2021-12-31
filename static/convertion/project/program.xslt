<?xml version="1.0"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:template match="/">
        
        <xsl:text disable-output-escaping="yes">&lt;root&gt;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;ddl&gt;</xsl:text>
        <xsl:variable name="rootElement"  select="//RootElementTag/text()"/>
        <xsl:apply-templates select="//complexType[not(@name) and ../@name!=$rootElement]" />
        <xsl:text disable-output-escaping="yes">&lt;/ddl&gt;</xsl:text>
        <br/><br/>        
        <xsl:apply-templates select="." mode="listAttributes"/>
        <xsl:text disable-output-escaping="yes">&lt;/root&gt;</xsl:text>
    </xsl:template>
    <xsl:template match="complexType">
        <xsl:choose>
            <xsl:when test="../@name and ../@name != /*/*/@name">
                DROP TABLE IF EXISTS <xsl:value-of select="../@name"/>;<br/>              
                CREATE TABLE <xsl:value-of select="../@name"/>(<br/>
                <xsl:value-of select="../@name"/>_id INT NOT NULL AUTO_INCREMENT, <br/>
                <xsl:apply-templates select="*/element" />
                <xsl:apply-templates select="attribute" />
                PRIMARY KEY(<xsl:value-of select="../@name"/>_id ) );
                <br/><br/>
            </xsl:when>
        </xsl:choose>
        
        
    </xsl:template>
    <xsl:template match="element">
        <xsl:apply-templates select="@type"/>
    </xsl:template>
    <xsl:template match="attribute">
        <xsl:apply-templates select="@type"/>
    </xsl:template>
    <xsl:template match="@type">
        <xsl:variable name="type" select="."/>
        <xsl:choose>
            <xsl:when test="$type = 'string' or $type = 'token' or $type = 'String' or $type = 'STRING'">
                <xsl:value-of select="../@name"/> VARCHAR (255),<br/>
            </xsl:when>
            <xsl:when test="$type = 'date' or $type = 'Date' or $type = 'DATE'">
                <xsl:value-of select="../@name"/> DATE,<br/>
            </xsl:when>
            <xsl:when test="$type = 'dateTime' or $type = 'DateTime' or $type = 'Datetime' or $type = 'DATETIME'">
                <xsl:value-of select="../@name"/> DATETIME,<br/>
                
            </xsl:when>
            <xsl:when test="$type = 'text' or $type = 'Text' or $type = 'TEXT'">
                <xsl:value-of select="../@name"/> TEXT,<br/>
            </xsl:when>
            <xsl:when test="$type = 'integer' or $type = 'Integer' or $type = 'INTEGER'">
                <xsl:value-of select="../@name"/> INT(11) NULL,<br/>
            </xsl:when>
            <xsl:when test="$type = 'image' or $type = 'Image' or $type = 'IMAGE'">
                <xsl:value-of select="../@name" /> IMAGE,<br/>
            </xsl:when>
            <xsl:when test="$type = 'url' or $type = 'Url' or $type = 'URL'">
                <xsl:value-of select="../@name"/> URL,<br/>
            </xsl:when>
            <xsl:when test="$type = 'decimal' or $type = 'Decimal' or $type = 'DECIMAL'">
                <xsl:value-of select="../@name"/> DECIMAL(30) NULL,<br/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:variable name="comple" select="name(//*[@name=$type and count(*/*)>0])" />
                <xsl:choose>
                    <xsl:when test=" $comple = 'complexType'">
                        <xsl:variable name="elm" select="//*[@name=$type and count(*/*)>0]" />
                        <xsl:choose>
                            <xsl:when test="$elm//sequence or $elm//all or $elm//choise ">
                                <xsl:apply-templates select="$elm//element" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$comple = 'simpleType'">
                        <xsl:variable name="simple" select="//*[@name=$type and count(*/*)>0]" />
                        <xsl:choose>
                            <xsl:when test="$simple//restriction">
                                <xsl:apply-templates select="$simple//element" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="simpleType">
        <xsl:choose>
            <xsl:when test="restriction/@base = 'integer'">
                INTEGER (10,0)<xsl:if test=".//minInclusive and .//maxInclusive">
                    constraint number_range_check
                    check(<xsl:value-of select="@name"/> &gt;=<xsl:value-of select=".//minInclusive/@value" /> and <xsl:value-of select="@name"/> &lt;=<xsl:value-of select=".//maxInclusive/@value" /> ),
                </xsl:if>              
            </xsl:when>
            <xsl:when test="restriction/@base = 'string'">
                <xsl:choose>
                    <xsl:when test=".//enumeration">
                        ENUM (<xsl:for-each select=".//enumeration">
                            <xsl:if test="position() != last()">'<xsl:value-of select="@value" />',</xsl:if>
                            <xsl:if test="position() = last()">'<xsl:value-of select="@value" />')</xsl:if>
                        </xsl:for-each>                        
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="*" mode="anonymousElement">
        <xsl:choose>
            <xsl:when test="name(.) = 'complexType' or name(.) = 'simpleType'">
                <xsl:choose>
                    <xsl:when test=" name(.) = 'complexType'">
                        <xsl:variable name="elm1" select="*/*/element" />
                        <xsl:choose>
                            <xsl:when test="$elm1//sequence or $elm1//all or $elm1//choise ">
                                <xsl:apply-templates select="$elm1//element" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="name(.) = 'simpleType'">
                        <xsl:variable name="simple1" select="*/*/element" />
                        <xsl:choose>
                            <xsl:when test="$simple1//restriction">
                                <xsl:apply-templates select="$simple1//element" />
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
                
            </xsl:when>
            <xsl:when test="name(.) != 'complexType' and name(.) != 'simpleType'">
                <xsl:apply-templates select="./*"  mode="anonymousElement"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    
    
    
    <xsl:template match="/" mode="listAttributes">
        <xsl:text disable-output-escaping="yes">&lt;dml&gt;</xsl:text><br/>
        <xsl:apply-templates select="//complexType[not(@name) and ../@name!= //RootElementTag/text()]" mode="listAttributes"/>
        <xsl:text disable-output-escaping="yes">&lt;/dml&gt;</xsl:text>
        
    </xsl:template>
    <xsl:template match="complexType" mode="listAttributes">
        <xsl:variable name="rootElement"  select="/*/*/@name"/>
        
        
        <xsl:choose>
            <xsl:when test="../@name">                
                <xsl:text disable-output-escaping="yes">&lt;table name="</xsl:text><xsl:value-of select="../@name" /><xsl:text disable-output-escaping="yes">"&gt;</xsl:text><br/>                
                <xsl:text disable-output-escaping="yes">&lt;attributes&gt;</xsl:text><br/>                
                <xsl:apply-templates select="*/element" mode="listAttributes"/>
                <xsl:apply-templates select="attribute" mode="listAttributes"/>
                <xsl:text disable-output-escaping="yes">&lt;/attributes&gt;</xsl:text> <br/>               
                <xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text><br/>
            </xsl:when>
        </xsl:choose>
        
        
    </xsl:template>
    <xsl:template match="element" mode="listAttributes">
        <xsl:apply-templates select="@type" mode="listAttributes"/>
    </xsl:template>
    <xsl:template match="attribute" mode="listAttributes">
        <xsl:apply-templates select="@type" mode="listAttributes"/>
    </xsl:template>
    <xsl:template match="@type" mode="listAttributes">
        <xsl:variable name="type" select="." />
        <xsl:choose>
            <xsl:when test="$type = 'string' or $type = 'token' or $type = 'String' or $type = 'STRING' or $type = 'date' or $type = 'Date' or $type = 'DATE' or $type = 'dateTime' or $type = 'DateTime' or $type = 'Datetime' or $type = 'DATETIME' or $type = 'text' or $type = 'Text' or $type = 'TEXT' or $type = 'integer' or $type = 'Integer' or $type = 'INTEGER' or $type = 'image' or $type = 'Image' or $type = 'IMAGE' or $type = 'url' or $type = 'Url' or $type = 'URL' or $type = 'decimal' or $type = 'Decimal' or $type = 'DECIMAL'">
                <xsl:text disable-output-escaping="yes">&lt;attribute&gt;</xsl:text>
                <xsl:value-of select="../@name"/>
                <xsl:text disable-output-escaping="yes">&lt;/attribute&gt;</xsl:text> <br/>               
            </xsl:when>            
            <xsl:otherwise>
                <xsl:variable name="comple" select="name(//*[@name=$type and count(*/*)>0])" />
                <xsl:choose>
                    <xsl:when test=" $comple = 'complexType'">
                        <xsl:variable name="elm" select="//*[@name=$type and count(*/*)>0]" />
                        <xsl:choose>
                            <xsl:when test="$elm//sequence or $elm//all or $elm//choice ">
                                <xsl:apply-templates select="$elm//element" mode="listAttributes"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$comple = 'simpleType'">
                        <xsl:variable name="simple" select="//*[@name=$type and count(*/*)>0]" />
                        <xsl:choose>
                            <xsl:when test="$simple//restriction">
                                <xsl:apply-templates select="$simple//element" mode="listAttributes"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    
    
</xsl:stylesheet>