DOCS  = tfg.pdf
TYPST = typst
# La plantilla está en el directorio padre: hay que ampliar la raíz del
# proyecto. Si copias fdi-tippex.typ junto a tu documento no hace falta.
FLAGS = --root ..

.PHONY: all watch clean

all: $(DOCS)

%.pdf: %.typ ../fdi-tippex.typ ../Escudo_UCM.png bibliografia.bib $(wildcard capitulos/*)
	$(TYPST) compile $(FLAGS) $< $@

watch:
	$(TYPST) watch $(FLAGS) $(DOCS:.pdf=.typ)

clean:
	rm -f $(DOCS)
