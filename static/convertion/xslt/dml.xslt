<?xml version="1.0"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">     
        <xsl:apply-templates select="//dml" />        
    </xsl:template>
    <xsl:template match="dml">
        <xsl:apply-templates select="table" />  
    </xsl:template>
    <xsl:template match="table">
        INSERT INTO <xsl:value-of select="@name"/> (<xsl:apply-templates select="./attributes"/>) VALUES   
        <xsl:apply-templates select="." mode="values"/>      
    </xsl:template>
    
    
    <xsl:template match="attributes">
        <xsl:for-each select=".//attribute">
            <xsl:if test="position() != last()"> <xsl:value-of select="."/>,</xsl:if><xsl:if test="position() = last()"><xsl:value-of select="."/> </xsl:if>
        </xsl:for-each>        
    </xsl:template>
    
    <xsl:template match="table" mode="values">
        <xsl:variable name="name"  select="@name"/>        
        <xsl:call-template name="show_values">            
            <xsl:with-param name="Tables" select="//*[name()=$name]"/>            
            <xsl:with-param name="attList" select="./attributes/attribute"/>     
        </xsl:call-template>
        
    </xsl:template>
    <xsl:template name="show_values">  
        
        <xsl:param name = "Tables" />
        <xsl:param name = "attList" />
        
        <xsl:for-each select="$Tables">
            
            <xsl:variable name="table2" select=".//*[name()=$attList[1]]/.." />
            <xsl:for-each select="$table2">                
                <xsl:call-template name="tableAndAttributes">
                    <xsl:with-param name="table" select="."/>
                    <xsl:with-param name="attList" select="$attList"/>
                </xsl:call-template> 
                <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="tableAndAttributes" >
        <xsl:param name="table"/>
        <xsl:param name="attList" /> (<xsl:for-each select="$attList"><xsl:variable name="attr" select="."/><xsl:if test="position() != last()">'<xsl:value-of select="$table//*[name()=$attr]"/>',</xsl:if><xsl:if test="position() = last()">'<xsl:value-of select="$table//*[name()=$attr]"/>'</xsl:if></xsl:for-each>)  
    </xsl:template>
    <xsl:template match="*" mode="values">
        
    </xsl:template>
    
</xsl:stylesheet>