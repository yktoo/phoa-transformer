<?xml version='1.0' encoding="utf-8"?>
<!-- Шаблон для фотоальбома PhoA -->
<!-- Автор: М.Вировец -->
<!-- Назначение: представление фотоальбома в виде одной WEB-страницы. 
     Страница снабжена оглавлением и имеет гиперссылки на оригинальные изображения.
     Если выбрана группа, вывод ограничивается этой группой и ее подгруппами. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- Заголовок и сводные данные по альбому в целом -->
    <xsl:template match="/album">
        <html>
            <head>
                <title>
                    <xsl:value-of select="@description"/>
                </title>
                <style>
                    .param { font-style: italic }
                    .value { font-weight: bold }
                </style>
            </head>
            <body>
                <h1>
                    <xsl:value-of select="@description"/>
                </h1>
                <table border="0">
                    <tr>
                        <td class="param">Версия</td>
                        <td class="value"><xsl:value-of select="@generator"/></td>
                    </tr>
                    <tr>
                        <td class="param">Изменен</td>
                        <td class="value"><xsl:value-of select="@saveddate"/>, <xsl:value-of select="@savedtime"/></td>
                    </tr>
                    <tr>
                        <td class="param">Качество эскиза</td>
                        <td class="value"><xsl:value-of select="@thumbquality"/></td>
                    </tr>
                    <tr>
                        <td class="param">Размер эскиза</td>
                        <td class="value"><xsl:value-of select="@thumbwidth"/> x <xsl:value-of select="@thumbheight"/></td>
                    </tr>
                    <tr>
                        <td class="param">Кол-во различных изображений</td>
                        <td class="value"><xsl:value-of select="count(pics/pic)"/></td>
                    </tr>
                    <tr>
                        <td class="param">Кол-во групп</td>
                        <td class="value"><xsl:value-of select="count(//groups)-1"/></td>
                    </tr>
                </table>
                <h2>Содержание</h2>
                <xsl:apply-templates select="//group[@selected='yes']" mode="tree"/>
                <xsl:apply-templates select="//group[@selected='yes']" mode="pics"/>
            </body>
        </html>
    </xsl:template>
    <!-- Дерево групп -->
    <xsl:template match="group" mode="tree">
        <dl>
            <dt>
                <a href="#{@id}">
                    <xsl:if test="@text=''">Фотоальбом</xsl:if>
                    <xsl:value-of select="@text"/>
                </a>
                <xsl:if test="count(refs/ref)!=0">
                    (<xsl:value-of select="count(refs/ref)"/>)
                </xsl:if>
                <xsl:apply-templates select="groups/group"  mode="tree"/>
            </dt>
        </dl>
    </xsl:template>
    <!-- Ключ для поиска картинки по ссылке -->
    <xsl:key name="PictId" match="/album/pics/pic" use="@id"/>
    <!-- Список картинок, входящих в группу -->
    <xsl:template match="group" mode="pics">
        <a name="{@id}">
        </a>
        <h3>
            <xsl:if test="@text=''">Фотоальбом</xsl:if>
            <xsl:value-of select="@text"/>
        </h3>
        <table>
            <xsl:apply-templates select="key('PictId', refs/ref)"/>
        </table>
        <xsl:apply-templates select="groups/group"  mode="pics"/>
    </xsl:template>
    <!-- Строка таблицы с одной картинкой -->
    <xsl:template match="pic">
        <tr>
            <td>
                <a target="_blank" href="{@folder}{@filename}">
                    <img src="{@thumbnail}"/>
                </a>
            </td>
            <td>
                <xsl:value-of select="@date"/>, <xsl:value-of select="@time"/>
                <br/>
                <xsl:value-of select="@place"/>
                <br/>
                <xsl:value-of select="@desc"/>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
