<?xml version='1.0' encoding="utf-8"?>
<!-- Шаблон для фотоальбома PhoA -->
<!-- Автор: М.Вировец -->
<!-- Назначение: печать этикеток к фотографиям. 
     Формируются этикетки для всех изображений ВЫБРАННОЙ ПОДГРУППЫ (без подгрупп).
     Каждая этикетка печатается с новой страницы и включает описание PhoA и метаданные EXIF.
	 Список требуемых метаданных EXIF находится в файле metadata.xml 
     (выводятся метаданные с атрибутом selected="y")
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- Ключ для поиска картинки по ссылке -->
    <xsl:key name="PictId" match="/album/pics/pic" use="@id"/>
    <!-- Заголовок HTML -->
    <xsl:template match="/album">
        <xsl:if test="count(//group[@selected='yes']/refs/ref)=0">
            <xsl:message terminate="yes">
                <xsl:text>Выбранная группа не содержит ни одного изображения!</xsl:text>
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
    <!-- Этикетка одной картинки -->
    <xsl:template match="pic">
        <table border="0" cellspacing="2" cellpadding="1">
            <tr>
                <td class="Param">Дата</td>
                <td class="Value"><xsl:value-of select="@date"/>, <xsl:value-of select="@time"/></td>
            </tr>
            <tr>
                <td class="Param">Место</td>
                <td class="Value"><xsl:value-of select="@place"/></td>
            </tr>
            <tr>
                <td class="Param">Описание</td>
                <td class="Value"><xsl:value-of select="@desc"/></td>
            </tr>
            <tr>
                <td class="Param">Файл</td>
                <td class="Value"><xsl:value-of select="@folder"/><xsl:value-of select="@filename"/></td>
            </tr>
            <tr>
                <td class="Param">Размер</td>
                <td class="Value"><xsl:value-of select="@filesize"/></td>
            </tr>
            <tr>
                <td class="Param">Ш х В</td>
                <td class="Value"><xsl:value-of select="@width"/> х <xsl:value-of select="@height"/></td>
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

