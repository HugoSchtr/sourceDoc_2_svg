<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei"
    version="2.0">
    <!-- Exclusion des préfixes TEI avec exclude-result-prefixes -->

    <!-- On configure l'output HTML, avec indentation automatique et encodage en UTF-8 -->
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <!-- On évite les espaces non voulus -->
    <xsl:strip-space elements="*"/>

    <!-- On configure les sorties HTML -->

    <xsl:template match="/">
        <!-- On stocke le nom le chemin du fichier courant -->
        <xsl:variable name="filename">
            <xsl:value-of select="//title"/>
        </xsl:variable>

        <xsl:variable name="image_width">
            <xsl:value-of select="replace(//sourceDoc/graphic/@width, 'px', '')"/>
        </xsl:variable>

        <xsl:variable name="image_height">
            <xsl:value-of select="replace(//sourceDoc/graphic/@height, 'px', '')"/>
        </xsl:variable>

        <!-- BRIQUES DE CONSTRUCTION DES SORTIES HTML -->

        <!-- On crée le head HTML -->
        <xsl:variable name="head">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <meta name="description" content="Transformation SVG d'un fichier TEI"/>
                <title>
                    <!-- On récupère le titre de l'oeuvre littéraire encodée directement dans le XML source -->
                    <xsl:value-of select="$filename"/>
                </title>
            </head>
        </xsl:variable>

        <!-- SORTIE HTML -->

        <!-- Avec xsl:result-document, on écrit les règles de transformation pour les output -->
        <!-- @href permet d'indiquer le chemin du fichier de sortie
        @method indique ici que la sortie sera en HTML
        @indent="yes" permet d'indiquer qu'on attend du HTML indenté -->
        <xsl:result-document method="html" indent="yes">
            <html>
                <xsl:copy-of select="$head"/>
                <body>
                    <main>
                        <div>
                            <svg xmlns="http://www.w3.org/2000/svg">
                                <xsl:attribute name="viewBox">
                                    <xsl:value-of
                                        select="concat('0 ', '0 ', $image_width, ' ', $image_height)"
                                    />
                                </xsl:attribute>
                                <xsl:apply-templates select="//sourceDoc"/>
                            </svg>
                            
                        </div>
                    </main>
                </body>
            </html>
        </xsl:result-document>

    </xsl:template>
    
    <xsl:template match="//surface">
<xsl:for-each select="zone">
    
    <xsl:variable name="path_points_without_M">
        <xsl:value-of select="remove(tokenize(path/@points, ' '), [1])"/>
    </xsl:variable>
    
    <xsl:variable name="M">
        <xsl:value-of select="concat('M ',replace(tokenize(path/@points, ' ')[1], ',', ' '))"/>
    </xsl:variable>
    
    <xsl:variable name="L">
        <xsl:value-of select="replace(concat(' L ', replace($path_points_without_M, ' ', ' L ')), ',', ' ')"/>
    </xsl:variable>
    <g>
        <polygon xmlns="http://www.w3.org/2000/svg">
            <xsl:attribute name="points">
                <xsl:value-of select="@points"/>
            </xsl:attribute>
            <xsl:attribute name="fill">transparent</xsl:attribute>
            <xsl:attribute name="stroke">none</xsl:attribute>
        </polygon>
        <path>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:attribute name="fill">none</xsl:attribute>
            <xsl:attribute name="stroke">none</xsl:attribute>
            <xsl:attribute name="d">
                <xsl:value-of select="concat($M, $L)"/>
            </xsl:attribute>
        </path>
        <text xmlns="http://www.w3.org/2000/svg">
            <xsl:attribute name="font-size">18.825px</xsl:attribute>
            <xsl:attribute name="textLength">791.0309448242188px</xsl:attribute>
            <textPath>            <xsl:attribute name="href">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
                <xsl:value-of select="line"/>
            </textPath>
        </text>
    </g>
</xsl:for-each>        

        
    </xsl:template>

</xsl:stylesheet>
