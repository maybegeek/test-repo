.PHONY : all md-to-html bib-to-yaml clean-yaml clean-html clean-all

ABLAGE = ./

ifdef WITH_ATS
ABLAGE = ./Ablage/
endif

PANDOC_HTML = \
	pandoc --standalone \
	--wrap=none --citeproc \
	--from markdown --to html5 \
	--template=layout/rvw-website.tmpl \
	--shift-heading-level-by=1 \
	--metadata date="`date +'%e. %B %Y'`" \
	--metadata date-meta="`date +'%Y-%m-%d'`" \
	$< -o $@

PANDOC_YAML = \
	pandoc --standalone \
	--from biblatex \
	--to markdown-smart \
	$< -o $@

MARKDOWN_DATEIEN  = $(wildcard *.md)
MD_AUSLASSEN = README.md test.md
MARKDOWN_DATEIEN := $(filter-out $(MD_AUSLASSEN), $(MARKDOWN_DATEIEN))
ZIEL_HTMLS = $(MARKDOWN_DATEIEN:%.md=$(ABLAGE)%.html)
CSL_DATEI = Mitteilungen-RVW.csl
TMPL_DATEI = layout/rvw-website.tmpl
BIB_DATEIEN = $(wildcard *.bib)
ZIEL_YAMLS = $(BIB_DATEIEN:%.bib=%.yaml)


all : bib-2-yaml md-2-html


md-2-html : $(ZIEL_HTMLS)
bib-2-yaml : $(ZIEL_YAMLS)

clean-html :
	rm $(ZIEL_HTMLS)

clean-yaml :
	rm $(ZIEL_YAMLS)

clean-all : clean-yaml clean-html

$(ABLAGE)%.html : %.md $(CSL_DATEI) $(TMPL_DATEI) $(ZIEL_YAMLS)
	@echo "* HTML-Datei erstellen: $@"
	$(PANDOC_HTML)

%.yaml : %.bib
	@echo "* YAML-Datei erstellen: $@"
	$(PANDOC_YAML)
