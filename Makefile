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

all: dist/kodi.zip

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

build/kodi-doc.tex: doc/main.tex src/HEADER $(wildcard doc/*.tex)
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

build/kodi-doc.pdf: build/latexmkrc build/kodi-doc.tex \
	build/tikzlibrarykodi.bapto.code.tex \
	build/tikzlibrarykodi.code.tex \
	build/tikzlibrarykodi.diorthono.code.tex \
	build/tikzlibrarykodi.ektropi.code.tex \
	build/tikzlibrarykodi.katharizo.code.tex \
	build/tikzlibrarykodi.koinos.code.tex \
	build/tikzlibrarykodi.mandyas.code.tex \
	build/tikzlibrarykodi.mitra.code.tex \
	build/tikzlibrarykodi.ozos.code.tex \
	build/tikzlibrarykodi.ramma.code.tex \
	build/tikzlibrarykodi.velos.code.tex \
	build/kodi.sty
	pushd $(@D); latexmk -gg

##[ DIST | Tree file structure ]################################################

dist/tds/doc/generic/kodi/kodi-doc.pdf: build/kodi-doc.pdf
	$(safe-cp)

dist/tds/doc/generic/kodi/kodi-doc.tex: build/kodi-doc.tex
	$(safe-cp)

dist/tds/doc/generic/kodi/README: build/README
	$(safe-cp)

dist/tds/doc: \
	dist/tds/doc/generic/kodi/kodi-doc.pdf \
	dist/tds/doc/generic/kodi/kodi-doc.tex \
	dist/tds/doc/generic/kodi/README

dist/tds/tex/context/third/kodi/t-kodi.tex: build/t-kodi.tex
	$(safe-cp)

dist/tds/tex/generic/kodi/tikzlibrarykodi.%.tex: build/tikzlibrarykodi.%.tex
	$(safe-cp)

dist/tds/tex/latex/kodi/kodi.sty: build/kodi.sty
	$(safe-cp)

dist/tds/tex/plain/kodi/kodi.tex: build/kodi.tex
	$(safe-cp)

dist/tds/tex: \
	dist/tds/tex/context/third/kodi/t-kodi.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.bapto.code.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.code.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.diorthono.code.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.ektropi.code.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.katharizo.code.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.koinos.code.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.mandyas.code.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.mitra.code.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.ozos.code.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.ramma.code.tex \
	dist/tds/tex/generic/kodi/tikzlibrarykodi.velos.code.tex \
	dist/tds/tex/latex/kodi/kodi.sty \
	dist/tds/tex/plain/kodi/kodi.tex

ifeq ($(SKIP_DOC),1)
dist/tds: dist/tds/tex
else
dist/tds: dist/tds/tex dist/tds/doc
endif

##[ DIST | Tree file structure ZIP ]############################################

dist/kodi.tds.zip: dist/tds
	pushd dist/tds; zip --recurse-paths ../kodi.tds.zip .

##[ DIST | Flat file structure ]################################################

dist/pkg/kodi: dist/kodi.tds.zip
	mkdir -p $@
	unzip -j $< -d $@
	cp $< $(@D)

##[ DIST | Flat file structure ZIP ]############################################

dist/kodi.zip: dist/pkg/kodi
	pushd dist/pkg; zip --recurse-paths ../kodi.zip .

##[ Format ]####################################################################

build/kodi-livedemo.fmt: kodi-livedemo.tex install 
	mkdir -p $(@D)
	cp $@ $<
	pushd $(@F); pdftex -ini "&latex $<\dump"

dist/kodi-livedemo.fmt: build/kodi-livedemo.fmt
	$(safe-cp)

##[ Local (un)installation ]####################################################

install: dist/tds
	pushd $<; cp -vR . $(UTREE)/

uninstall:
	find $(UTREE) -type d -name kodi -prune -exec rm -vrf {} \;

##[ Development ]###############################################################

# NOTE: this is useful when writing the manual
watch:
	ls doc/*.tex | entr -n -s 'make clean build/kodi-doc.pdf'
