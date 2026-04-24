DOCS     = tfg.pdf tfm.pdf
LATEX    = lualatex
BIBER    = biber
FLAGS    = -interaction=nonstopmode -halt-on-error
BUILDDIR = build

export TEXINPUTS := .:..:

.PHONY: clean

all: $(DOCS)

%.pdf: $(BUILDDIR)/%.pdf
	cp $< $@

$(BUILDDIR)/%.pdf: %.tex ../fdi-simplex.cls ../Escudo_UCM.png $(wildcard capitulos/*) | $(BUILDDIR)
	$(LATEX) $(FLAGS) -output-directory=$(BUILDDIR) $<
	$(BIBER) $(BUILDDIR)/$*
	$(LATEX) $(FLAGS) -output-directory=$(BUILDDIR) $<
	$(LATEX) $(FLAGS) -output-directory=$(BUILDDIR) $<

$(BUILDDIR):
	@mkdir -p $(BUILDDIR)

clean:
	rm -rf $(BUILDDIR)
