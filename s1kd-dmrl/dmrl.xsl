<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- Convert a DML to a series of s1kd-new* calls -->
  
  <xsl:param name="no-issue" select="false()"/>

  <xsl:output method="text"/>

  <xsl:template match="*">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <xsl:template match="dml">
    <xsl:apply-templates select="dmlContent"/>
  </xsl:template>

  <xsl:template match="dmlEntry">
    <xsl:choose>
      <xsl:when test="dmRef">
        <xsl:text>s1kd-newdm</xsl:text>
        <xsl:if test="$no-issue">
          <xsl:text> -N</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="pmRef">
        <xsl:text>s1kd-newpm</xsl:text>
        <xsl:if test="$no-issue">
          <xsl:text> -N</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="commentRef">
        <xsl:text>s1kd-newcom</xsl:text>
      </xsl:when>
      <xsl:when test="dmlRef">
        <xsl:text>s1kd-newdml</xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="*"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="dmCode">
    <xsl:text> -# </xsl:text>
    <xsl:apply-templates select="." mode="text"/>
  </xsl:template>

  <xsl:template match="dmCode" mode="text">
    <xsl:value-of select="@modelIdentCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@systemDiffCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@systemCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@subSystemCode"/>
    <xsl:value-of select="@subSubSystemCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@assyCode"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@disassyCode"/>
    <xsl:value-of select="@disassyCodeVariant"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@infoCode"/>
    <xsl:value-of select="@infoCodeVariant"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="@itemLocationCode"/>
    <xsl:if test="@learnCode">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@learnCode"/>
      <xsl:value-of select="@learnEventCode"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="issueInfo">
    <xsl:text> -n </xsl:text>
    <xsl:value-of select="@issueNumber"/>
    <xsl:text> -w </xsl:text>
    <xsl:value-of select="@inWork"/>
  </xsl:template>

  <xsl:template match="language">
    <xsl:text> -L </xsl:text>
    <xsl:value-of select="@languageIsoCode"/>
    <xsl:text> -C </xsl:text>
    <xsl:value-of select="@countryIsoCode"/>
  </xsl:template>

  <xsl:template match="techName">
    <xsl:text> -t "</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="infoName">
    <xsl:text> -i "</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="responsiblePartnerCompany">
    <xsl:if test="@enterpriseCode">
      <xsl:text> -R </xsl:text>
      <xsl:value-of select="@enterpriseCode"/>
    </xsl:if>
    <xsl:if test="enterpriseName">
      <xsl:text> -r "</xsl:text>
      <xsl:value-of select="enterpriseName"/>
      <xsl:text>"</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="security">
    <xsl:text> -c </xsl:text>
    <xsl:value-of select="@securityClassification"/>
  </xsl:template>

</xsl:stylesheet>
