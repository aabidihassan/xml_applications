<?xml version="1.0" ?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="element">
DROP TABLE IF EXISTS
<xsl:value-of select="@name" />;
CREATE TABLE
</xsl:template>
</xsl:stylesheet>