<?xml version='1.0' encoding="utf-8"?>
<!-- Template for PhoA album -->
<!-- Author: M.Virovets -->
<!-- Purpose: photo labels print. 
     Labels are generated for all pictures in the SELECTED GROUP (without subgroups).
     Each label is printed at new page. It inludes PhoA description and EXIF metadata.
	 List of required EXIF metadata is taken from the file metadata.xml 
     (only metadata with attribute selected="y" are printed).
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- Key for picture lookup by reference -->
    <xsl:key name="PictId" match="/album/pics/pic" use="@id"/>
    <!-- HTML title-->
    <xsl:template match="/album">
        <xsl:if test="count(//group[@selected='yes']/refs/ref)=0">
            <xsl:message terminate="yes">
                <xsl:text>Selected group does not contain any picture!</xsl:text>
            </xsl:message>
        </xsl:if>
        <html>
            <head>
                <style>
                    table 	{ page-break-after: always }
                    .param 	{ font-family: Verdana, Arial; font-size: 12px }
                    .value 	{ font-weight: bold }
                </style>
            </head>
            <body>
                <xsl:apply-templates select="key('PictId', //group[@selected='yes']/refs/ref)"/>
            </body>
        </html>
    </xsl:template>
    <!-- One picture label -->
    <xsl:template match="pic">
        <table border="0" cellspacing="2" cellpadding="1">
            <tr>
                <td class="Param">Date</td>
                <td class="Value"><xsl:value-of select="@date"/>, <xsl:value-of select="@time"/></td>
            </tr>
            <tr>
                <td class="Param">Place</td>
                <td class="Value"><xsl:value-of select="@place"/></td>
            </tr>
            <tr>
                <td class="Param">Description</td>
                <td class="Value"><xsl:value-of select="@desc"/></td>
            </tr>
            <tr>
                <td class="Param">FileName</td>
                <td class="Value"><xsl:value-of select="@folder"/><xsl:value-of select="@filename"/></td>
            </tr>
            <tr>
                <td class="Param">FileSize</td>
                <td class="Value"><xsl:value-of select="@filesize"/></td>
            </tr>
            <tr>
                <td class="Param">W x H</td>
                <td class="Value"><xsl:value-of select="@width"/> x <xsl:value-of select="@height"/></td>
            </tr>
            <xsl:variable name="currpic" select="."/>
            <xsl:for-each select="document('metadata.xml')/metadata/exif[@selected='y']">
                <xsl:variable name="currtag" select="@tag"/>
                <xsl:if test="$currpic/exif[@tag=$currtag]/@value != ''">
                    <tr>
                        <td class="Param"><xsl:value-of select="@name"/></td>
                        <td class="Value"><xsl:value-of select="$currpic/exif[@tag=$currtag]/@value"/></td>
                    </tr>
                </xsl:if>
            </xsl:for-each>
        </table>
    </xsl:template>
</xsl:stylesheet>
