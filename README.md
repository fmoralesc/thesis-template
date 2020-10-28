# clpthesis

This repository contains a LaTeX template for dissertations.

Design-wise, it is inspired by `tufte-latex`, but it has a more traditional
layout (more suitable for text-heavy documents).

You can check a sample file [here](sample.pdf).

## the `clpsthesis` package

The `clpsthesis` package provides a class the can be used for the preparation
of a dissertation using a mulfi-file workflow. The same class can be used for
the main file and for the separate chapters (see below for instructions).

### Dependencies

The `clpsthesis` class depends on many LaTeX packages, starting with the
powerful `memoir` class on which it is based. It also uses:

- `standalone`, to handle subfiles.
- `adobecaslon` or `libertine` for the main fonts (Caslon is preferred). For
  math, `libertinust1math` is used,
- `titlesec`, for changing the format of section headings,
- `paralist`, for in-paragraph lists,
- `enumitem`, for lists formatting,
- `amsmath` and `amssymb`, for general math support,
- `bussproofs`, `prooftrees` for logic support,
- `tikz`, for diagrams,
- `xcolor` and `xcolor-material`, for colors,
- `graphicx`, for graphics support,
- `longtable` and `booktabs`, for tables,
- `attrib`, for attributions,
- `multicol`, for multi-column environments,
- `pdfx`, for hypertext and PDF-A support.
- `pdfcomment`, for annotations.
- `etoolbox`, `afterpage`, `fixltx2e`, `textcomp`, `microtype`.

## How to use the template

- Clone this repository.
- Copy the file `clpsthesis.cls` to your document directory.
- Decide on the name of your main file, and where you will put your chapters,
  if needed. `clpsthesis` assumes the default that the main file will be called
  `main.tex`, and the chapters will be in the `chapters/` folder.
- Edit the `Makefile`, if necessary:

	```Makefile
	mainfile = main.tex
	chaptersdir = ./chapters/
	```

- Add `\documentclass{clpsthesis}` to your main document's preamble.
- Set the project configuration in a file called `project.conf.tex` (see
  below).

	```latex
	\def\maintitle{Thesis title}
	\def\mainauthor{Author Name}
	\def\maindate{\today}
	...
	```

- For PDF-A support, you must specify some metadata in a file called
  `main.xmpdata` (replace `main` with the name of your main file), with the
  contents:

	```latex
	\Title        {Thesis title}
	\Author       {Author Name}
	\Copyright    {Copyright \copyright\ 2XXX "Author Name"}
	\Keywords     {tag1\sep
		       tag2\sep
		       tag3}
	\Subject      {Abstract}
	```

- Create chapters in your desired folder, and include them in your main file:

	```latex
	\include{chapters/mychapter}
	```

- Chapter files can use the `clpsthesis` class too, although it is recommended
  to pass the `article` option. That way, you can compile them separately in a
  format that makes sense. Because of the way the `standalone` package works,
  the metadata needs to be specified as follows:

	```latex
	\documentclass[article]{clpsthesis}

	\def\thischaptertitle{This chapter's title}

	\metactitle{\thischaptertitle}

	\begin{document}
	\ctitle{\thischaptertitle}
	...
	\end{document}
	```

- Profit!

## Building the files

There is a `Makefile` provided. To build the main text:

```sh
make main
```

or simply `make` (this clears the auxiliary files after compiling the
document).

To build a chapter:

```sh
make chapters/mychapter
```

To clean the auxiliary files:

```sh
make clean
```

## The `pandoc` workflow

Some utilities are provided to incorporate `pandoc` into the production of the
dissertation:

- There is a pandoc template (`chapter-template.pandoc`) which can be used to generate latex files
  conforming to the format that `clpsthesis` expects from chapter files. The
  source markdown files need to provide at least a `title` field, and a
  `fileid`:

	```
	---
	title: 'My title'
	fileid: myfile
	---
	```

	When compiled to latex, this markdown file will become

	```latex
	\documentclass[article]{clpsthesis}

	\def\myfiletitle{My title}

	\metactitle{\myfiletitle}

	\begin{document}
	\ctitle{\myfiletitle}
	...
	\end{document}
	```

- There is a `pandoc` rule for the Makefile that will compile all `*.md` files
  in the `chapters/` folder into `latex` files.

## `git` hooks

- A script is provided to update latex files from staged markdown files. This
  can be used as a git pre-commit hook:

	```
	cp scripts/update-tex-from-md .git/hooks/pre-commit
	```

- This script can be used on its own as well, to update the tex files of any
  modified markdown files

	```
	./scripts/update-tex-from-md -m --no-stage
	```

- Another script is provided to compile the main file if the last commit has
  been tagged with `[newver] ` and the main file is older than that commit (or
  if the file doesn't exist). This is suitable as a git post-commit hook:


	```
	cp scripts/update-main-if-tagged .git/hooks/post-commit
	```
