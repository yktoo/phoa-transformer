<?xml version='1.0' encoding="utf-8"?>
<!-- Template for PhoA album -->
<!-- Author: M.Virovets -->
<!-- Purpose: represent the photo album as one WEB page. 
     The page has a table of content and has hyperlinks to original images.
     If a group is selected, then output is restricted to this group and its subgroups. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- Heading and album summary -->
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
                        <td class="param">Version</td>
                        <td class="value"><xsl:value-of select="@generator"/></td>
                    </tr>
                    <tr>
                        <td class="param">Modified</td>
                        <td class="value"><xsl:value-of select="@saveddate"/>, <xsl:value-of select="@savedtime"/></td>
                    </tr>
                    <tr>
                        <td class="param">Thumbnail quality</td>
                        <td class="value"><xsl:value-of select="@thumbquality"/></td>
                    </tr>
                    <tr>
                        <td class="param">Thumbnail size</td>
                        <td class="value"><xsl:value-of select="@thumbwidth"/> x <xsl:value-of select="@thumbheight"/></td>
                    </tr>
                    <tr>
                        <td class="param">Number of distinct pictures</td>
                        <td class="value"><xsl:value-of select="count(pics/pic)"/></td>
                    </tr>
                    <tr>
                        <td class="param">Number of groups</td>
                        <td class="value"><xsl:value-of select="count(//groups)-1"/></td>
                    </tr>
                </table>
                <h2>Contents</h2>
                <xsl:apply-templates select="//group[@selected='yes']" mode="tree"/>
                <xsl:apply-templates select="//group[@selected='yes']" mode="pics"/>
            </body>
        </html>
    </xsl:template>
    <!-- Group tree -->
    <xsl:template match="group" mode="tree">
        <dl>
            <dt>
                <a href="#{@id}">
                    <xsl:if test="@text=''">Photo Album</xsl:if>
                    <xsl:value-of select="@text"/>
                </a>
                <xsl:if test="count(refs/ref)!=0">
                    (<xsl:value-of select="count(refs/ref)"/>)
                </xsl:if>
                <xsl:apply-templates select="groups/group"  mode="tree"/>
            </dt>
        </dl>
    </xsl:template>
    <!-- Key for picture lookup by reference -->
    <xsl:key name="PictId" match="/album/pics/pic" use="@id"/>
    <!-- List of pictures in one group -->
    <xsl:template match="group" mode="pics">
        <a name="{@id}">
        </a>
        <h3>
            <xsl:if test="@text=''">Photo Album</xsl:if>
            <xsl:value-of select="@text"/>
        </h3>
        <table>
            <xsl:apply-templates select="key('PictId', refs/ref)"/>
        </table>
        <xsl:apply-templates select="groups/group"  mode="pics"/>
    </xsl:template>
    <!-- Table row with one picture -->
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
