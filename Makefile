# The nightbare-fuel below is the Makefile for project "sealion"
# Variables
.SUFFIXES: .Rnw .tex .pdf
.SECONDARY: %.tex
TEX = pdflatex -shell-escape -interaction=nonstopmode -file-line-error
SRC = master
PDF = $(SRC:=.pdf)

# Meta-rules: Rnw -> tex; tex -> pdf
.Rnw.tex:
	@echo Running R code chunks in report $< to fetch figures...
	#R CMD Sweave --encoding=utf-8 --options=concordance=TRUE $*.Rnw
	R CMD Sweave --encoding=utf-8 $*.Rnw
	@echo done!

.tex.pdf:
	@echo Typesetting $<...
	$(TEX) $*.tex
	@echo    done!
	# PDF compression not required, as all graphics vector or optimized raster
	#gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dUseCIEColor \
	#-dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$*_print.pdf $*.pdf

# Make targets
#all: clean $(PDF) clean
all: clean $(PDF)


clean:
	@echo Deleting temporary files...
	rm -fv *-concordance.tex *.synctex.gz *.log *.idx *.ilg *.blg \
	*.ind *.aux *.bcf *.bbl *.out *.toc *.ptc *.run.xml *.pyc *.tex
	@echo done!

# Dependencies: Re-compile only if chapters change
master.pdf: $(wildcard ./parts/*.Rnw)
