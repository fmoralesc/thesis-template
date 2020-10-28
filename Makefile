to_clean = *.aux *.fls *.log *.fdb_latexmk *.out *.sta *.toc *.upa *.upb *.bbl *.bcf *.blg *.run.xml *.xmpi *.lot *.lof
output = *.pdf
mainfile = main.tex
chaptersdir = chapters
bibdir = bibliographies
pandoc_template = chapter-template.pandoc

.DELETE_ON_ERROR:
all: | main

main: | pandoc
	latexmk --pdf $(mainfile)

display: | pandoc
	latexmk -pv --pdf $(mainfile)


.PHONY: wc wcm entr display clean clean_aux_main clean_main clean_aux_chapters clean_chapters clean_all

wc:
	cd ./$(chaptersdir) ; \
	find -maxdepth 1 -name '*.md' -exec wc -w {} \; | awk '{print $$1}' | paste -s -d+ - | bc

wcm:
	cd ./$(chaptersdir) ; \
	find -maxdepth 1 -name '*.md' ! -path "*apx*" -exec wc -w {} \; | awk '{print $$1}' | paste -s -d+ - | bc


entr:
	ls **.tex **.cls $(chaptersdir)/*.md $(bibdir)/*.bib| entr make display

all_forced: | clean pandoc_forced
	latexmk --pdf $(mainfile)

pandoc:
	./scripts/update-tex-from-md -m --no-stage $(f)

pandoc_forced:
	$(foreach file, $(wildcard $(chaptersdir)/*.md), \
	pandoc --wrap=preserve --biblatex \
	-f markdown-auto_identifiers \
	--template $(pandoc_template) \
	--filter pandoc-include \
	-o $(basename $(file)).tex \
	$(file);)

chapters/%:
	make pandoc f=$(@:chapters%/=%);  \
	cd ./$(chaptersdir) ; \
	BIBINPUTS=.. latexmk --pdf $(@:chapters/%=%).tex

clean_aux_main:
	rm -rf $(to_clean)

clean_main: clean_aux_main
	rm -rf $(output)

clean_aux_chapters:
	cd ./$(chaptersdir); \
	rm -rf $(to_clean)

clean_chapters: clean_aux_chapters
	cd ./$(chaptersdir); \
	rm -rf $(output)

clean: clean_aux_main clean_aux_chapters

clean_all: clean_main clean_chapters

sample.pdf: clean
	latexmk --pdf sample.tex
