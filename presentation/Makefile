# targets
all: 20120216-AdvBioInfo-course.pp.pdf 20120216-AdvBioInfo-course.handout.pdf
handout: 20120216-AdvBioInfo-course.handout.pdf
pp: 20120216-AdvBioInfo-course.pp.pdf
# sample.text.pdf -- don't build article version by default

TEXINPUTS=.:$(RHBEAMER):
export TEXINPUTS

SHOW=no
PDFVIEWER=evince
LATEX=pdflatex

.PHONY: all clean handout pp
all:

# Don't touch this, HAHA.
clean: TEXS=$(patsubst %.tex,%,\
	$(filter-out %.pp.tex %.handout.tex,\
	$(wildcard *.tex)))
clean: PRESENTATION_TMPS=$(wildcard \
	$(addsuffix .pp.tex,$(TEXS)) \
	$(addsuffix .handout.tex,$(TEXS)))
clean: TEX_TMPS=$(filter-out %.tex %.png %.orig %.zal, \
	$(wildcard $(addsuffix .*,$(TEXS))))
clean:
	$(RM) $(wildcard $(PRESENTATION_TMPS) $(TEX_TMPS))

%.pdf: %.tex
	$(LATEX) $<
	$(LATEX) $<
	if [ "$(SHOW)" == "yes" ]; then $(PDFVIEWER) $@; fi

%.png: %.pdf
	pstoimg -depth 8 -density 120 -antialias -aaliastext -multipage -out $@ $<
	touch $@

%.eps: %.svg
	inkscape -z -f $< -D --export-area-snap -E $@

%.pdf: %.eps
	epstopdf --outfile=$@ $<


# presentation/handout texs/pdfs
%.pp.tex: %.tex
	echo '\def\presentationHead#1{#1}\def\handoutHead#1{}' >$@
	echo '\input $<' >>$@

%.handout.tex: %.tex
	echo '\def\presentationHead#1{#1}\def\handoutHead#1{}' >$@
	echo '\PassOptionsToClass{handout}{beamer}' >>$@
	echo '\input $<' >>$@

%.pp.pdf: %.pp.tex %.tex
%.handout.pdf: %.handout.tex %.tex
