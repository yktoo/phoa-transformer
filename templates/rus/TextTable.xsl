<?xml version='1.0' encoding="utf-8"?>

<!-- Шаблон для фотоальбома PhoA -->
<!-- Автор: М.Вировец -->
<!-- Назначение: вывод описаний и метаданных всех изображений альбома в виде таблицы. 
     Данные выводятся в виде TXT-файла, колонки разделяются символами табуляции 
	 Список требуемых метаданных EXIF находится в файле metadata.xml 
     (выводятся метаданные с атрибутом selected="y").
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="text"/>

	<xsl:template match="/album">
    	<xsl:text>Дата&#x9;</xsl:text>
		<xsl:text>Время&#x9;</xsl:text>
		<xsl:text>Место&#x9;</xsl:text>
		<xsl:text>Описание&#x9;</xsl:text>
		<xsl:text>Файл&#x9;</xsl:text>
		<xsl:text>Размер&#x9;</xsl:text>
		<xsl:text>Ширина&#x9;</xsl:text>
		<xsl:text>Высота&#x9;</xsl:text>
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
