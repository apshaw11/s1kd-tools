#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>
#include <string.h>
#include <libxml/tree.h>
#include <libxslt/xslt.h>
#include <libxslt/transform.h>
#include <libxslt/xsltutils.h>
#include "identity.h"

bool includeIdentity = false;

void addIdentity(xmlDocPtr style)
{
	xmlDocPtr identity;
	xmlNodePtr stylesheet, first, template;

	identity = xmlReadMemory((const char *) identity_xsl, identity_xsl_len, NULL, NULL, 0);
	template = xmlFirstElementChild(xmlDocGetRootElement(identity));

	stylesheet = xmlDocGetRootElement(style);

	first = xmlFirstElementChild(stylesheet);

	if (first) {
		xmlAddPrevSibling(first, xmlCopyNode(template, 1));
	} else {
		xmlAddChild(stylesheet, xmlCopyNode(template, 1));
	}

	xmlFreeDoc(identity);
}

xmlDocPtr transformDoc(xmlDocPtr doc, xmlNodePtr stylesheets)
{
	xmlDocPtr src;
	xmlNodePtr cur;

	src = xmlCopyDoc(doc, 1);

	for (cur = stylesheets->children; cur; cur = cur->next) {
		xmlDocPtr res, styledoc;
		xmlChar *path;
		xsltStylesheetPtr style;

		path = xmlNodeGetContent(cur);

		styledoc = xmlReadFile((char *) path, NULL, 0);

		if (includeIdentity) {
			addIdentity(styledoc);
		}

		style = xsltParseStylesheetDoc(styledoc);

		xmlFree(path);

		res = xsltApplyStylesheet(style, doc, NULL);

		xsltFreeStylesheet(style);
		xmlFreeDoc(doc);

		doc = res;
	}

	xmlDocSetRootElement(src, xmlCopyNode(xmlDocGetRootElement(doc), 1));

	xmlFreeDoc(doc);

	return src;
}
	
void transformFile(const char *path, xmlNodePtr stylesheets, const char *out)
{
	xmlDocPtr doc;

	doc = xmlReadFile(path, NULL, 0);

	doc = transformDoc(doc, stylesheets);

	if (out) {
		xmlSaveFile(out, doc);
	} else {
		xmlSaveFile(path, doc);
	}

	xmlFreeDoc(doc);
}

void showHelp(void)
{
	puts("Usage: s1kd-transform [-h?] [-s <stylesheet> ...] [-i] [-o <file>] <datamodules>");
	puts("");
	puts("Options:");
	puts("  -h -?    Show usage message.");
	puts("  -s <stylesheet>  Apply XSLT stylesheet to data modules.");
	puts("  -i               Include identity template.");
	puts("  -o <file>        Output to <path> instead of overwriting (- for stdout).");
	puts("  <datamodules>    Data modules to apply transformations to.");
}

int main(int argc, char **argv)
{
	int i;

	xmlNodePtr stylesheets;

	char *out = NULL;

	stylesheets = xmlNewNode(NULL, BAD_CAST "stylesheets");

	while ((i = getopt(argc, argv, "s:io:h?")) != -1) {
		switch (i) {
			case 's':
				xmlNewChild(stylesheets, NULL, BAD_CAST "stylesheet", BAD_CAST optarg);
				break;
			case 'i':
				includeIdentity = true;
				break;
			case 'o':
				out = strdup(optarg);
				break;
			case 'h':
			case '?':
				showHelp();
				exit(0);
		}
	}

	for (i = optind; i < argc; ++i) {
		transformFile(argv[i], stylesheets, out);
	}

	if (out) {
		free(out);
	}

	return 0;
}