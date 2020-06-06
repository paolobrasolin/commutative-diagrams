PKG     = commutative-diagrams
SHELL   = bash
UTREE   = $(shell kpsewhich --var-value TEXMFHOME)
YEAR    = $(shell date +"%Y")
DATE    = $(shell date +"%Y/%m/%d")
VERSION = UNRELEASED
SKIP_DOC = 0

INTERPOLATIONS  = s@<<FILE>>@$(@F)@g;
INTERPOLATIONS += s@<<DATE>>@$(DATE)@g;
INTERPOLATIONS += s@<<YEAR>>@$(YEAR)@g;
INTERPOLATIONS += s/<<VERSION>>/$(VERSION)/g;

define safe-cp
mkdir -p $(@D)
cp $< $@
endef

##[ Default ]###################################################################

all: dist/$(PKG).zip

##[ hygiene ]###################################################################

clean:
	rm -rf build
clobber: clean
	rm -rf dist

##[ BUILD | Sourcecode ]########################################################

build/%.tex: src/HEADER src/%.tex 
	mkdir -p build
	cat $^ | sed "$(INTERPOLATIONS)" > $@

build/%.sty: src/HEADER src/%.sty
	mkdir -p build
	cat $^ | sed "$(INTERPOLATIONS)" > $@

##[ BUILD | Documentation ]#####################################################

build/README: doc/README
	$(safe-cp)

build/$(PKG)-doc.tex: doc/main.tex src/HEADER $(wildcard doc/*.tex)
	mkdir -p build
	cat src/HEADER $< \
	| awk -F '[{}]' '/^\\input{.*}$$/{system("cat $(<D)/"$$2".tex"); next}1' \
	| awk -F '[{}]' '/^\\input{.*}$$/{system("cat $(<D)/"$$2".tex"); next}1' \
	| sed "$(INTERPOLATIONS)" \
	> $@

# NOTE: the black magic above interpolates the `\input`s.
# It's the most portable solution I could come up with:
#   ruby -pe '$$_.gsub!(/^\\input{(.*?)}$$/) { File.read("$(<D)/#{Regexp.last_match[1]}.tex")}'
#   awk -F '[{}]' '/^\\include{.*}$/{system("cat "$2".tex"); next}1'
#   sed 's@\\input{\(.*\)}@cat $(<D)/\1.tex@e' # NOTE: this requires GNU sed, so MacOS is cut off

build/latexmkrc: doc/latexmkrc
	$(safe-cp)

build/$(PKG)-doc.pdf: build/$(PKG)-doc.tex build/latexmkrc \
	build/tikzlibrary$(PKG).bapto.code.tex \
	build/tikzlibrary$(PKG).code.tex \
	build/tikzlibrary$(PKG).diorthono.code.tex \
	build/tikzlibrary$(PKG).ektropi.code.tex \
	build/tikzlibrary$(PKG).katharizo.code.tex \
	build/tikzlibrary$(PKG).koinos.code.tex \
	build/tikzlibrary$(PKG).mandyas.code.tex \
	build/tikzlibrary$(PKG).mitra.code.tex \
	build/tikzlibrary$(PKG).ozos.code.tex \
	build/tikzlibrary$(PKG).ramma.code.tex \
	build/tikzlibrary$(PKG).velos.code.tex \
	build/$(PKG).sty
	pushd $(<D); latexmk -gg $(<F)

##[ DIST | Tree file structure ]################################################

dist/tds/doc/generic/$(PKG)/$(PKG)-doc.pdf: build/$(PKG)-doc.pdf
	$(safe-cp)

dist/tds/doc/generic/$(PKG)/$(PKG)-doc.tex: build/$(PKG)-doc.tex
	$(safe-cp)

dist/tds/doc/generic/$(PKG)/README: build/README
	$(safe-cp)

dist/tds/doc: \
	dist/tds/doc/generic/$(PKG)/$(PKG)-doc.pdf \
	dist/tds/doc/generic/$(PKG)/$(PKG)-doc.tex \
	dist/tds/doc/generic/$(PKG)/README

dist/tds/tex/context/third/$(PKG)/t-$(PKG).tex: build/t-$(PKG).tex
	$(safe-cp)

dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).%.tex: build/tikzlibrary$(PKG).%.tex
	$(safe-cp)

dist/tds/tex/latex/$(PKG)/$(PKG).sty: build/$(PKG).sty
	$(safe-cp)

dist/tds/tex/latex/$(PKG)/kodi.sty: build/kodi.sty
	$(safe-cp)

dist/tds/tex/plain/$(PKG)/$(PKG).tex: build/$(PKG).tex
	$(safe-cp)

dist/tds/tex: \
	dist/tds/tex/context/third/$(PKG)/t-$(PKG).tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).bapto.code.tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).code.tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).diorthono.code.tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).ektropi.code.tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).katharizo.code.tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).koinos.code.tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).mandyas.code.tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).mitra.code.tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).ozos.code.tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).ramma.code.tex \
	dist/tds/tex/generic/$(PKG)/tikzlibrary$(PKG).velos.code.tex \
	dist/tds/tex/latex/$(PKG)/$(PKG).sty \
	dist/tds/tex/latex/$(PKG)/kodi.sty \
	dist/tds/tex/plain/$(PKG)/$(PKG).tex

ifeq ($(SKIP_DOC),1)
dist/tds: dist/tds/tex
else
dist/tds: dist/tds/tex dist/tds/doc
endif

##[ DIST | Tree file structure ZIP ]############################################

dist/$(PKG).tds.zip: dist/tds
	pushd dist/tds; zip --recurse-paths ../$(PKG).tds.zip .

##[ DIST | Flat file structure ]################################################

dist/pkg/$(PKG): dist/$(PKG).tds.zip
	mkdir -p $@
	unzip -j $< -d $@
	cp $< $(@D)

##[ DIST | Flat file structure ZIP ]############################################

dist/$(PKG).zip: dist/pkg/$(PKG)
	pushd dist/pkg; zip --recurse-paths ../$(PKG).zip .

##[ Format ]####################################################################

build/$(PKG)-livedemo.fmt: $(PKG)-livedemo.tex install 
	mkdir -p $(@D)
	cp $@ $<
	pushd $(@F); pdftex -ini "&latex $<\dump"

dist/$(PKG)-livedemo.fmt: build/$(PKG)-livedemo.fmt
	$(safe-cp)

##[ Local (un)installation ]####################################################

install: dist/tds
	pushd $<; cp -vR . $(UTREE)/

uninstall:
	find $(UTREE) -type d -name $(PKG) -prune -exec rm -vrf {} \;

##[ Development ]###############################################################

# NOTE: this is useful when writing the manual
watch:
	ls doc/*.tex | entr -n -s 'make clean build/$(PKG)-doc.pdf'
