% vim: filetype=tex foldmethod=manual
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{clpsthesis}[0.1]

\RequirePackage{etoolbox}

% if 'final', the sizes are different
\newbool{clpsfinal}
\DeclareOption{final}{
	\global\booltrue{clpsfinal}
	\PassOptionsToClass{final}{pdfcomment}
	}

% if article, some things need to be adjusted for standalone files
\newbool{clpsarticle}
\DeclareOption{article}{
	\global\booltrue{clpsarticle}
	\PassOptionsToClass{article}{memoir}
	\PassOptionsToClass{oneside}{memoir}
}
% if article, we hide the author unless noanon
\newbool{clpsanon}
\global\booltrue{clpsanon}
\DeclareOption{noanon}{
	\global\boolfalse{clpsanon}
}

\newbool{onesided}
\DeclareOption{oneside}{
	\global\booltrue{onesided}
	\PassOptionsToClass{oneside}{memoir}
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax

\LoadClass[a4paper,11pt]{memoir}

% For handling of includes
\RequirePackage[subpreambles]{standalone}

% Sizes
\ifbool{clpsfinal}
{
	% Final version is 24x16cm (ADS recommendation)
	\setstocksize{24cm}{16cm}
	\settrimmedsize{24cm}{16cm}{*}
	\semiisopage[10]
	\checkandfixthelayout
}{}

% Fonts and font sizes
\RequirePackage[T1]{fontenc}
\IfFileExists{adobecaslon.sty}{
	\RequirePackage{adobecaslon}
}{
	\RequirePackage[semibold,type1]{libertine}
}
\RequirePackage{libertinust1math}
\RequirePackage[scaled=0.85]{PTSans}
\RequirePackage[scaled=0.9]{inconsolata}
\DeclareSymbolFont{symbolsC}{U}{txsyc}{m}{n}
\DeclareMathSymbol{\strictif}{\mathrel}{symbolsC}{74}
\DeclareMathSymbol{\boxright}{\mathrel}{symbolsC}{128}
\DeclareMathSymbol{\boxRight}{\mathrel}{symbolsC}{136} % Lewis’s stronger ‘would’ counterfactual
\DeclareMathSymbol{\diamondRight}{\mathrel}{symbolsC}{140} % Lewis’s stronger ‘might’ counterfactual
\DeclareMathSymbol{\diamonddot}{\mathord}{symbolsC}{144} % Lewis’s inner necessity
\RequirePackage{textcomp} % provides euro and other symbols
\RequirePackage{tipa}
\RequirePackage{microtype}
\setSingleSpace{1.15}

\pagestyle{plain}

\newenvironment{localsize}[1]
{
	\clearpage
	\let\orignewcommand\newcommand
	\let\newcommand\renewcommand
	\makeatletter
	\input{mem#1.clo}
	\makeatother
	\let\newcommand\orignewcommand
}
{
	\clearpage
}

% Sectioning

\renewcommand*{\thepart}{\arabic{part}}
\renewcommand*{\parttitlefont}{\normalfont\Large\MakeUppercase}
\renewcommand*{\partnamefont}{\normalfont\scshape\MakeLowercase}
\renewcommand*{\partnumfont}{\normalfont\scshape\MakeLowercase}

\renewcommand*{\printpartname}{\partnamefont Part}
\renewcommand*{\printpartnum}{\partnumfont\thepart}

\renewcommand{\midpartskip}{\par\parbox{0.5in}{\hrulefill}\par}
\renewcommand{\beforepartskip}{\vspace*{\fill}}
\renewcommand{\afterpartskip}{\vspace*{\fill}}

\let\appendixpagenameorig\appendixpagename
\renewcommand{\appendixpagename}{\scshape\Large\appendixpagenameorig}
\chapterstyle{section}
\renewcommand{\chaptitlefont}{\normalfont\huge\itshape}
\renewcommand{\chapnumfont}{\normalfont\Huge\mdseries}
\RequirePackage{titlesec}
\setsecnumdepth{subsection}
\titleformat{\section}{\normalfont\Large\itshape}{{\upshape\small\thesection}}{.5em}{}
\titleformat{\subsection}{\normalfont\large\itshape}{{\upshape\small\thesubsection}}{.5em}{}
\titleformat{\subsubsection}{\normalfont\normalsize\itshape}{{\upshape\small\thesubsubsection}}{.5em}{}
\titleformat*{\paragraph}{\normalfont\normalsize\itshape}
\setcounter{tocdepth}{2}
% if we are in article mode, we don't want to add the chapter number to headings
\ifbool{clpsarticle}{
	\counterwithout{section}{chapter}
}{}
\setsecnumformat{{\upshape\csname the#1\endcsname\quad}}

% TOC
\renewcommand{\cftpartfont}{\scshape}
\renewcommand{\cftpartpagefont}{\mdseries}
\renewcommand{\cftpartname}{\textsmaller{Part }}
\renewcommand{\cftchapterfont}{\scshape}
\renewcommand{\cftchapterpagefont}{\mdseries}
\renewcommand{\cftsectionfont}{\itshape}
\renewcommand{\cftsubsectionfont}{\itshape}

\makeatletter
\renewcommand{\@tocrmarg}{\@pnumwidth plus1fil} % <-- Revised
\makeatother

\renewcommand{\cftpartleader}{\quad}
\renewcommand{\cftpartafterpnum}{\cftparfillskip}
\renewcommand{\cftchapterleader}{\quad}
\renewcommand{\cftchapterafterpnum}{\cftparfillskip}
\renewcommand{\cftsectionleader}{\quad}
\renewcommand{\cftsectionafterpnum}{\cftparfillskip}
\renewcommand{\cftsubsectionleader}{\quad}
\renewcommand{\cftsubsectionafterpnum}{\cftparfillskip}

% Enumerations
\RequirePackage{paralist}
\RequirePackage{enumitem}
\setlist[description]{style=nextline}
\setlist[enumerate]{noitemsep,topsep=1pt}
\setlist[itemize]{noitemsep,topsep=1pt}

% Descriptions
\RequirePackage{relsize}
\renewcommand*{\descriptionlabel}[1]{\hspace\labelsep\normalfont\scshape\textsmaller{#1}}

% Math, logic, diagrams support
\RequirePackage{amssymb}
\RequirePackage{amsmath}
\RequirePackage{bussproofs}
\RequirePackage[tableaux]{prooftrees}
\RequirePackage{tikz}
\usetikzlibrary{matrix}
\usetikzlibrary{positioning}
\usetikzlibrary{patterns}
\usetikzlibrary{decorations.pathreplacing}
\usetikzlibrary{cd}
\RequirePackage{tikz-network}

% Graphics
\RequirePackage{xcolor}
\RequirePackage{xcolor-material}
\RequirePackage{graphicx}
\RequirePackage{grffile}
\graphicspath{{gfx/}{../gfx/}}

% Tables
\RequirePackage{longtable}
\RequirePackage{booktabs}

% Misc
% memoir already defines these, but moredefs (which attrib depends on) redefines them,
% causing trouble. They are close enough that undefining them is fine.
\let\providelength\undefined
\let\providecounter\undefined
\RequirePackage{attrib}
\RequirePackage{multicol}
\setlength{\epigraphrule}{0pt}
\RequirePackage{nccfoots} % for showing publication details for published chapters
\renewcommand{\eminnershape}{\itshape}
\RequirePackage[splitrule]{footmisc}
\raggedbottom
\feetatbottom
\RequirePackage{xspace}

% Hypertext
\RequirePackage[a-2a]{pdfx} % Create PDF A-2a, for archival with some accessibility features
\hypersetup{
	breaklinks=true,
	linktocpage=true
}

\ifbool{clpsfinal}
{
	\hypersetup{
		hidelinks=true,
	}
}{
	\hypersetup{
		colorlinks=true,
		linkcolor=MaterialIndigoA700,
		urlcolor=MaterialIndigoA700,
		citecolor=MaterialIndigoA700,
	}
}
\urlstyle{same} % urls in main font
\RequirePackage{bookmark}

\RequirePackage{cleveref}

% Bibliography
\RequirePackage{csquotes}
\RequirePackage[backend=biber,style=philosophy-classic]{biblatex}
\setlength\bibitemsep{1pt}
\renewcommand*\finalnamedelim{\addspace\&\space}
\ifbool{clpsarticle}
{\AtEndDocument{
		\printbibliography[heading=subbibliography]
}}
{}

\usepackage[figure,table]{totalcount}

\let\oldlistoftables\listoftables
\renewcommand{\listoftables}{\iftotaltables\oldlistoftables\fi}
\let\oldlistoffigures\listoffigures
\renewcommand{\listoffigures}{\iftotalfigures\oldlistoffigures\fi}

% TODOs and commments
\RequirePackage{pdfcomment}
% Utility commands

% Adds a blank page after the current one
\RequirePackage{afterpage}
\newcommand\blankpage{%
    \ifbool{onesided}{}{
	    \afterpage{\null
	    \thispagestyle{empty}%
	    %\addtocounter{page}{-1}%
	    \newpage}
    }
}

% TITLE page

\newcommand\committeeitem[1]{Prof.\ dr.\ #1\par}
\newcommand\thesistitlepage{
	\thispagestyle{titlingpage}

	\begin{minipage}{0.70\textwidth}
		\smaller\sffamily\thesisinstitution
	\end{minipage}
	\begin{minipage}{0.30\textwidth}\raggedleft
		\hfill\includegraphics[width=0.9\linewidth]{\thesisinstitutionlogo}
	\end{minipage}
	\null\vspace{10em}

	\begin{center}

	\begin{minipage}{\textwidth*9/16}
		\setSpacing{1.5}
		\begin{center}
		{
		\LARGE\textsc \maintitle
		}
		\vspace{4em}\\
		{\Large \mainauthor}
		\end{center}
	\end{minipage}

	\null\vfill

	\begin{minipage}{\textwidth}
	\begin{multicols}{2}
	\small \sffamily
	Examination commmittee:\par
	\ifdefempty{\thesischair}{}{
		Prof.\ dr.\ \thesischair, chair\par
	}
	\ifdefempty{\thesissupervisor}{}{
		Prof.\ dr.\ \thesissupervisor, supervisor\par
	}
	\ifdef{\thesiscommittee}{
		\forlistloop{\committeeitem}{\thesiscommittee}
	}{}
	\ifdefempty{\thesisexternalexaminer}{}{
		External examiner:\par
		\thesisexternalexaminer\par
	}
	\vspace{1em}
	\ifdefempty{\thesisdate}{}{
		Examination date: \thesisdate\par
	}

	\columnbreak
	\raggedleft
	Dissertation presented in partial\\ fulfilment of the requirements
	for\\ the degree of \textbf{\thesisdegree}
	\end{multicols}
	\end{minipage}

	\null\vspace{2em}

	\begin{minipage}{\textwidth}
	\begin{center}
	{\sffamily \mainplace, \maindate}
	\end{center}
	\end{minipage}

	\end{center}
	\blankpage
	\newpage
}


% DEDICATION
\newcommand\dedication[2][to]{
	\thispagestyle{empty}
	\begin{center}
	\textsc{#1}\\
	#2
	\end{center}
}

% KEYWORDS
\providecommand\keywords[1]{
	\textbf{Keywords:} #1
}

% For chapter files

% We include the chapters using the standalone package with the
% subpreambles option, so we cannot set titles or metadata in the
% preambles without affecting the whole document.
% What we do is a little bit of indirection: we define a macro for the
% current chapter title, which we will use if compiling a subfile standalone.
% We do this as follows:
%
% \documentclass[article]{clpsthesis}
% \def\chaptertitle{My title}
% \metactitle{\chaptertitle}
% \begin{document}
% \ctitle{\chaptertitle}
% ..
% \end{document}

% Ideally we could autogenerate all of this, but because the preambles are
% grouped together we could easily overwrite settings, so we have to make do with
% this slightly clumsy interface.

% Titles for chapter files
\providecommand\ctitle[1]{
	\ifbool{clpsarticle}
	{
		\maketitle
	}{
		\chapter{#1}
	}
}

% Metadata for chapters
\providecommand\metactitle[1]{
	\ifbool{clpsarticle}
	{
		\title{#1}
		\ifbool{clpsanon}{}{\author{\ifdef{\mainauthor}{\mainauthor}{}}}
		\date{\today}
	}{}
}

% Chapter/paper toggle
\providecommand\thischapter{\ifbool{clpsarticle}{this paper}{this chapter}}

\RequirePackage{lplfitch}
\renewcommand{\formula}[1]{\ensuremath{#1}}
\renewcommand{\intro}[1]{\formula{#1,}{\bfseries Intro:}}
\renewcommand{\elim}[1]{\formula{#1,}{\bfseries Elim:}}

\providecommand\entryfootnote[1]{\Footnotetext{\dag}{\textsf{#1}.}}

% Settings
% must include a definition of \maintitle, \mainauthor and \maindate
\include{project.conf}

