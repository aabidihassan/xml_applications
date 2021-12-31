<?xml version="1.0"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <xsl:apply-templates select="//complexType[not(@name)]" />
    </xsl:template>
    <xsl:template match="complexType">
        <xsl:choose>
            <xsl:when test="@name">
                DROP TABLE IF EXISTS
                <xsl:value-of select="@name" />
                ;
                CREATE TABLE
                <xsl:value-of select="@name" />
                (
                <br></br>
                <xsl:value-of select="@name" />
                _id INT NOT NULL,
                <br></br>
                <xsl:apply-templates select="*/element" />
                <xsl:apply-templates select="attribute" />
                PRIMARY KEY(
                <xsl:value-of select="@name" />
                _id ) );
                <br></br>
                <br></br>
                <br></br>
            </xsl:when>
            <xsl:when test="../@name">
                DROP TABLE IF EXISTS
                <xsl:value-of select="../@name" />
                ;
                CREATE TABLE
                <xsl:value-of select="../@name" />
                (
                <br></br>
                <xsl:value-of select="../@name" />
                _id INT NOT NULL,
                <br></br>
                <xsl:apply-templates select="*/element" />
                <xsl:apply-templates select="attribute" />
                PRIMARY KEY(
                <xsl:value-of select="../@name" />
                _id ) );
                <br></br>
                <br></br>
                <br></br>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="element">
        <xsl:apply-templates select="@type" />
    </xsl:template>
    <xsl:template match="attribute">
        <xsl:apply-templates select="@type" />
    </xsl:template>
    <xsl:template match="@type">
        <xsl:variable name="type" select="." />
        <xsl:choose>
            <xsl:when test="$type = 'string' or $type = 'token'">
                <xsl:value-of select="../@name" />
                VARCHAR2 (*),
            </xsl:when>
            <xsl:when test="$type = 'date' or $type = 'Date' or $type = 'DATE'">
                <xsl:value-of select="../@name" />
                DATE NOT NULL,
            </xsl:when>
            <xsl:when test="$type = 'dateTime' or $type = 'DateTime' or $type = 'Datetime' or $type = 'DATETIME'">
                <xsl:value-of select="../@name" />
                DATETIME,
            </xsl:when>
            <xsl:when test="$type = 'text' or $type = 'Text' or $type = 'TEXT'">
                <xsl:value-of select="../@name" />
                TEXT,
            </xsl:when>
            <xsl:when test="$type = 'integer' or $type = 'Integer' or $type = 'INTEGER'">
                <xsl:value-of select="../@name" />
                INTEGER (10,0) NOT NULL,
            </xsl:when>
            <xsl:when test="$type = 'image' or $type = 'Image' or $type = 'IMAGE'">
                <xsl:value-of select="../@name" />
                IMAGE,
            </xsl:when>
            <xsl:when test="$type = 'url' or $type = 'Url' or $type = 'URL'">
                <xsl:value-of select="../@name" />
                URL,
            </xsl:when>
            <xsl:when test="$type = 'decimal' or $type = 'Decimal' or $type = 'DECIMAL'">
                <xsl:value-of select="../@name" />
                DECIMAL(30,15),
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
        <br></br>
    </xsl:template>
    
    <xsl:template match="simpleType">
        <xsl:choose>
            <xsl:when test="restriction/@base = 'integer'">
                INTEGER (10,0)
                <xsl:if test=".//minInclusive and .//maxInclusive">
                    constraint number_range_check
                    check(
                    <xsl:value-of select="@name" />
                    &gt;=
                    <xsl:value-of select=".//minInclusive/@value" />
                    and number &lt;=
                    <xsl:value-of select=".//maxInclusive/@value" />
                    ),
                </xsl:if>
                
            </xsl:when>
            <xsl:when test="restriction/@base = 'string'">
                <xsl:choose>
                    <xsl:when test=".//enumeration">
                        ENUM (
                        <xsl:for-each select=".//enumeration">
                            <xsl:if test="position() != last()">
                                '
                                <xsl:value-of select="@value" />
                                ',
                            </xsl:if>
                            <xsl:if test="position() = last()">
                                '
                                <xsl:value-of select="@value" />
                                '),
                            </xsl:if>
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
</xsl:stylesheet>