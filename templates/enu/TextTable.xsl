<?xml version='1.0' encoding="utf-8"?>

<!-- Template for PhoA album -->
<!-- Author: M.Virovets -->
<!-- Purpose: table of descriptions and metadata of all pictures in the album. 
     Output has TXT format, columns are TAB-divided 
	 List of required EXIF metadata is taken from the file metadata.xml 
     (only metadata with attribute selected="y" are printed).
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="text"/>

	<xsl:template match="/album">
    	<xsl:text>Date&#x9;</xsl:text>
		<xsl:text>Time&#x9;</xsl:text>
		<xsl:text>Place&#x9;</xsl:text>
		<xsl:text>Description&#x9;</xsl:text>
		<xsl:text>FileName&#x9;</xsl:text>
		<xsl:text>FileSize&#x9;</xsl:text>
		<xsl:text>Width&#x9;</xsl:text>
		<xsl:text>Height&#x9;</xsl:text>
    	<xsl:for-each select="document('metadata.xml')/metadata/exif[@selected='y']">
	    	<xsl:value-of select="@name"/><xsl:text>&#x9;</xsl:text>
		</xsl:for-each>
		<xsl:text>&#xD;&#xA;</xsl:text>
	  	<xsl:apply-templates select="pics/pic"/>
  	</xsl:template>


    <xsl:template match="pic">
    	<xsl:value-of select="@date"/><xsl:text>&#x9;</xsl:text>
		<xsl:value-of select="@time"/><xsl:text>&#x9;</xsl:text>
		<xsl:value-of select="@place"/><xsl:text>&#x9;</xsl:text>
		<xsl:value-of select="@desc"/><xsl:text>&#x9;</xsl:text>
		<xsl:value-of select="@filename"/><xsl:text>&#x9;</xsl:text>
		<xsl:value-of select="@filesize"/><xsl:text>&#x9;</xsl:text>
		<xsl:value-of select="@width"/><xsl:text>&#x9;</xsl:text>
		<xsl:value-of select="@height"/><xsl:text>&#x9;</xsl:text>

		<xsl:variable name="currpic" select="."/> 
    	<xsl:for-each select="document('metadata.xml')/metadata/exif[@selected='y']">
			<xsl:variable name="currtag" select="@tag"/> 
			<xsl:value-of select="$currpic/exif[@tag=$currtag]/@value"/><xsl:text>&#x9;</xsl:text>
		</xsl:for-each>
		<xsl:text>&#xD;&#xA;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
