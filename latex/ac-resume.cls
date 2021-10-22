%% 専攻科特別研究発表会講演予稿クラスファイル
%% Ver.0.1 <2021-10-04>

% 依存パッケージ
\RequirePackage{expl3, xparse, l3keys2e}

% クラス宣言
\NeedsTeXFormat{LaTeX2e}
\ProvidesExplPackage {ac-resume} {2021/10/04} {0.1}
  {Document class for the resume of advanced courses}

% (u)pTeX 用パッチ
\sys_if_engine_ptex:T { \RequirePackage { plautopatch } }
\sys_if_engine_uptex:T { \RequirePackage { plautopatch } }

% クラスオプション
\bool_new:N \g_acr_nogutter_bool
\bool_new:N \g_acr_japanese_bool
\str_new:N  \g_acr_fonts_str
\bool_new:N \g_acr_fonts_default_bool
\bool_new:N \g_acr_fonts_ms_bool
\bool_new:N \g_acr_fonts_word_bool
\bool_new:N \g_acr_fonts_no_bool

\clist_new:N \g__acr_options_clist
\clist_new:N \g__acr_disallowed_options_clist
\seq_new:N \g__acr_disallowed_options_seq

% jlreq に渡す
\clist_gset:Nn \g__acr_disallowed_options_clist
  {
    article, report, book, paper, fontsize, jafontsize, jafontscale,
    line_length, number_of_lines, head_space, foot_space, gutter, fore_edge,
    fore-edge, headfoot_verticalposition, headfoot_sidemargin, column_gap,
    baselineskip, linegap, hanging_punctuation, narrow_kanjiskip,
    sidenote_length, use_reverse_pagination, landscape, tate, oneside, twoside,
    oneclumn, twocolumn, titlepage, notitlepage, openright, openany
  }
\clist_map_inline:Nn \g__acr_disallowed_options_clist
  {
    \seq_gput_right:Nx \g__acr_disallowed_options_seq { \tl_to_str:n { #1 } }
  }
\cs_new:Nn \__acr_process_class_option:
  {
    \cs_if_exist:NF \l_keys_key_str
      { \cs_set_eq:NN \l_keys_key_str \l_keys_key_tl }
    \seq_if_in:NoTF \g__acr_disallowed_options_seq { \l_keys_key_str }
      { \msg_warning:nnx { ac-resume } { disallowed-option } { \l_keys_key_str } }
      { \clist_gput_right:No \g__acr_options_clist { \CurrentOption } }
  }

% オプション実行
\keys_define:nn { ac-resume / option }
  {
    nogutter .bool_gset:N = \g_acr_nogutter_bool,
    nogutter .default:n = true,
    japanese .bool_gset:N = \g_acr_japanese_bool,
    japanese .default:n = true,
    fonts    .code:n = { \str_gset:Nn \g_acr_fonts_str { #1 } },
    fonts    .initial:n = default
  }
\ProcessKeysOptions { ac-resume / option }
\PassOptionsToClass { \g__acr_options_clist } { jlreq }

\str_case:VnF \g_acr_fonts_str
  {
    { no } { }
    { default }
    {
      \bool_gset:Nn \g_acr_fonts_default_bool { 1 }
    }
    { ms }
    {
      \bool_gset:Nn \g_acr_fonts_ms_bool { 1 }
    }
    { word }
    {
      \sys_if_engine_luatex:F
        {
          \ClassError { ac-resume } { Unsupported~ fonts~ setting }
            {
              This~ is~ a~ LuaTeX-specific~ 'fonts'~ option:~
              '\g_acr_fonts_str'.
            }
        }
      \bool_gset:Nn \g_acr_fonts_word_bool { 1 }
    }
  }
  {
    \ClassError { ac-resume } { Unknown~ fonts~ setting }
      {
        Invalid~ value~ for~ the~ 'fonts'~ option:~
        '\g_acr_fonts_str'.
      }
  }

% オプションを指定して jlreq を読み込む
\LoadClass
  [
    paper=a4,
    fontsize=10bp,
    baselineskip=15bp,
    twocolumn,
    column_gap=7.5mm,
    line_length=23zw,
    number_of_lines=48,
    head_space=21.1mm, % +1.1mm は微調整
    twoside,
    \bool_if:NF \g_acr_nogutter_bool { gutter=25mm }
  ] { jlreq }

% maketitle の要素の設定
\NewDocumentCommand\titleJP    { m }  { \cs_new:Nn \g_acr_title_jp:   { #1 } }
\NewDocumentCommand\titleEN    { m }  { \cs_new:Nn \g_acr_title_en:   { #1 } }
\NewDocumentCommand\authorJP   { m }  { \cs_new:Nn \g_acr_author_jp:  { #1 } }
\NewDocumentCommand\authorEN   { m }  { \cs_new:Nn \g_acr_author_en:  { #1 } }
\NewDocumentCommand\major      { m }  { \cs_new:Nn \g_acr_major:      { #1 } }
\NewDocumentCommand\supervisor { m }  { \cs_new:Nn \g_acr_supervisor: { #1 } }
\RenewDocumentCommand\abstract { +m } { \cs_new:Nn \g_acr_abstract:   { #1 } }
\NewDocumentCommand\keywords   { m }  { \cs_new:Nn \g_acr_keywords:   { #1 } }
\NewDocumentCommand\program    { m }  { \cs_new:Nn \g_acr_program:    { #1 } }

% \maketitleの設定（表紙と目次）
\RenewDocumentCommand\maketitle {} { \twocolumn[\@maketitle] }
\RenewDocumentCommand\@maketitle {}
  {
    \centering
    { \huge\bfseries \g_acr_title_jp: \\[ 2bp ] } % 微調整
    { \LARGE\bfseries \g_acr_title_en: \\[ 15bp ] }
    { \Large\bfseries \g_acr_author_jp: （\g_acr_author_en:） \\[ 15bp ] }
    { \normalsize\bfseries \g_acr_major: （\g_acr_supervisor:） \\[ 15bp ] }
    \begin { minipage } [ t ] { 150mm }
      \setlength{\parindent}{1\zw}
      \small
      { \g_acr_abstract: \\[ 15bp ] }
      { \noindent { \bfseries Keywords:~ } \g_acr_keywords: }
    \end { minipage }
    \vspace* { 16bp }
  }

% section 等の設定
\ModifyHeading { section }
  {
    font={\large\bfseries},
    align=center,
    label_format={\thesection .},
    after_label_space=3bp,
    lines=1,
    before_lines=1,
    after_lines=1
  }
\ModifyHeading { subsection }
  {
    font={\bfseries},
    label_format={\thesubsection .},
    after_label_space=3bp,
    lines=1,
    before_lines=1
  }
\ModifyHeading { subsubsection }
  {
    font={\bfseries},
    label_format={\thesubsubsection .},
    after_label_space=3bp,
    lines=1,
    before_lines=1
  }
% *section が連なった時の処理（expl3 内だと動作しない）
\ExplSyntaxOff
\SetBlockHeadingSpaces
  {
    {_section{before_lines=1},_subsection{*}}
    {_subsection{*},_subsubsection{before_lines=0}}
    {_section{before_lines=1},_subsection{*},_subsubsection{before_lines=0}}
  }
\ExplSyntaxOn

% ページ番号の設定
\NewPageStyle { ac-pagestyle } { nombre=\g_acr_program:-\thepage }
\pagestyle{ac-pagestyle}

% 英語キャプション対応
\bool_if:NF \g_acr_japanese_bool
  {
    \tl_set:Nn \contentsname { Table~ of~ Contents }
    \tl_set:Nn \indexname { Index }
    \tl_set:Nn \listfigurename { List~ of~ Figures }
    \tl_set:Nn \figurename { Figure }
    \tl_set:Nn \listtablename { List~ of~ Tables }
    \tl_set:Nn \tablename { Table }
    \tl_set:cn { fnum@figure } { \figurename\nobreakspace\thefigure }
    \tl_set:cn { fnum@table } { \tablename\nobreakspace\thetable }
  }

% footnote を MS Word に合わせて数字だけにする．
\RenewDocumentCommand\thefootnote {} { \arabic{footnote} }

% 警告 "underfull \vbox (badness XXX)" を減らすためにすごく緩くする
\def\@textbottom{\vskip 0pt~plus~10bp}%
\let\@texttop\relax

% 参考文献
\tl_set:Nn \indexname { 参考文献 }
\cs_set:Npn \@biblabel #1 { #1) }

\renewenvironment{thebibliography}[1]{%
  \jlreq@oldfontcommand@enable
  \section*{\refname}%
  \@mkboth{\refname}{\refname}%
  \small
  \list{\@biblabel{\@arabic\c@enumiv}}%
    {\settowidth\labelwidth{\@biblabel{#1}}%
    \labelsep=1\zw
    \leftmargin\labelwidth
    \advance\leftmargin\labelsep
    \itemindent=0pt
    \@openbib@code
    \usecounter{enumiv}%
    \let\p@enumiv\@empty
    \renewcommand\theenumiv{\@arabic\c@enumiv}}%
  \sloppy
  \clubpenalty4000
  \@clubpenalty\clubpenalty
  \widowpenalty4000%
  \sfcode`\.\@m
}{%
  \def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
  \endlist
  \jlreq@oldfontcommand@disable
}

% フォントの設定
\bool_if:NT \g_acr_fonts_default_bool
  {
    \sys_if_engine_ptex:T
      {
        \RequirePackage [ utf8 ] { inputenc }
        \RequirePackage [ T1 ] { fontenc }
        \RequirePackage [ deluxe ] {otf}
        \RequirePackage [ noalphabet ] { pxchfon }
        \setmediumminchofont { HaranoAjiMincho-Light.otf }
        \setboldminchofont   { HaranoAjiGothic-Bold.otf }
        \setmediumgothicfont { HaranoAjiGothic-Medium.otf }
        \setboldgothicfont   { HaranoAjiGothic-Bold.otf }
        \DeclareFontShape { JY1 } { hmc } { b } { n } { <->ssub*hmc/bx/n } {}
        \DeclareFontShape { JT1 } { hmc } { b } { n } { <->ssub*hmc/m/n }  {}
        \DeclareFontShape { JY1 } { hgt } { b } { n } { <->ssub*hgt/bx/n } {}
        \DeclareFontShape { JT1 } { hgt } { b } { n } { <->ssub*hgt/m/n }  {}
        \RequirePackage [ defaultsups ] { newtxtext }
        \RequirePackage { newtxmath }
        \RequirePackage { helvet }
      }
    \sys_if_engine_uptex:T
      {
        \RequirePackage [ T1 ] { fontenc }
        \RequirePackage [ deluxe, uplatex ] {otf}
        \RequirePackage [ noalphabet ] { pxchfon }
        \setmediumminchofont { HaranoAjiMincho-Light.otf }
        \setboldminchofont   { HaranoAjiGothic-Bold.otf }
        \setmediumgothicfont { HaranoAjiGothic-Medium.otf }
        \setboldgothicfont   { HaranoAjiGothic-Bold.otf }
        \DeclareFontShape { JY2 } { hmc } { b } { n } { <->ssub*hmc/bx/n } {}
        \DeclareFontShape { JT2 } { hmc } { b } { n } { <->ssub*hmc/m/n }  {}
        \DeclareFontShape { JY2 } { hgt } { b } { n } { <->ssub*hgt/bx/n } {}
        \DeclareFontShape { JT2 } { hgt } { b } { n } { <->ssub*hgt/m/n }  {}
        \RequirePackage [ defaultsups ] { newtxtext }
        \RequirePackage { newtxmath }
        \RequirePackage { helvet }
      }
    \sys_if_engine_luatex:T
      {
        \RequirePackage [ T1 ] { fontenc }
        \RequirePackage { luatexja-fontspec }
        \setmainjfont
          [
            Ligatures      = TeX,
            BoldFont       = HaranoAjiGothic-Bold.otf,
            ItalicFont     = HaranoAjiMincho-Light.otf,
            BoldItalicFont = HaranoAjiGothic-Bold.otf
          ] { HaranoAjiMincho-Light.otf }
        \setsansjfont
          [
            Ligatures      = TeX,
            BoldFont       = HaranoAjiGothic-Bold.otf,
            ItalicFont     = HaranoAjiGothic-Medium.otf,
            BoldItalicFont = HaranoAjiGothic-Bold.otf
          ] { HaranoAjiGothic-Medium.otf }
        \RequirePackage [ defaultsups ] { newtxtext }
        \RequirePackage { newtxmath }
        \RequirePackage { helvet }
      }
  }
\bool_if:NT \g_acr_fonts_ms_bool
  {
    \sys_if_engine_ptex:T
      {
        \RequirePackage [ utf8 ] { inputenc }
        \RequirePackage [ T1 ] { fontenc }
        \RequirePackage [ deluxe ] {otf}
        \RequirePackage [ noalphabet ] { pxchfon }
        \setmediumminchofont [ 0 ] { msmincho.ttc }
        \setboldminchofont   [ 0 ] { HGRGE.TTC }
        \setmediumgothicfont [ 0 ] { msgothic.ttc }
        \setboldgothicfont   [ 0 ] { HGRGE.TTC }
        \DeclareFontShape { JY1 } { hmc } { b } { n } { <->ssub*hmc/bx/n } {}
        \DeclareFontShape { JT1 } { hmc } { b } { n } { <->ssub*hmc/m/n }  {}
        \DeclareFontShape { JY1 } { hgt } { b } { n } { <->ssub*hgt/bx/n } {}
        \DeclareFontShape { JT1 } { hgt } { b } { n } { <->ssub*hgt/m/n }  {}
        \RequirePackage [ defaultsups ] { newtxtext }
        \RequirePackage { newtxmath }
        \RequirePackage { helvet }
      }
    \sys_if_engine_uptex:T
      {
        \RequirePackage [ T1 ] { fontenc }
        \RequirePackage [ deluxe, uplatex ] {otf}
        \RequirePackage [ alphabet ] { pxchfon }
        \setmediumminchofont [ 0 ] { msmincho.ttc }
        \setboldminchofont   [ 0 ] { HGRGE.TTC }
        \setmediumgothicfont [ 0 ] { msgothic.ttc }
        \setboldgothicfont   [ 0 ] { HGRGE.TTC }
        \DeclareFontShape { JY2 } { hmc } { b } { n } { <->ssub*hmc/bx/n } {}
        \DeclareFontShape { JT2 } { hmc } { b } { n } { <->ssub*hmc/m/n }  {}
        \DeclareFontShape { JY2 } { hgt } { b } { n } { <->ssub*hgt/bx/n } {}
        \DeclareFontShape { JT2 } { hgt } { b } { n } { <->ssub*hgt/m/n }  {}
        \RequirePackage [ defaultsups ] { newtxtext }
        \RequirePackage { newtxmath }
        \RequirePackage { helvet }
      }
    \sys_if_engine_luatex:T
      {
        \RequirePackage [ T1 ] { fontenc }
        \RequirePackage { luatexja-fontspec }
        \setmainjfont
          [
            Ligatures      = TeX,
            BoldFont       = HGRGE.TTC:0,
            ItalicFont     = msmincho.ttc:0,
            BoldItalicFont = HGRGE.TTC:0
          ] { msmincho.ttc:0 }
        \setsansjfont
          [
            Ligatures      = TeX,
            BoldFont       = HGRGE.TTC:0,
            ItalicFont     = msgothic.ttc:0,
            BoldItalicFont = HGRGE.TTC:0
          ] { msgothic.ttc:0 }
          \RequirePackage [ defaultsups ] { newtxtext }
          \RequirePackage { newtxmath }
        \RequirePackage { helvet }
      }
  }
\bool_if:NT \g_acr_fonts_word_bool
  {
    \sys_if_engine_luatex:T
      {
        \RequirePackage [ T1 ] { fontenc }
        \RequirePackage { luatexja-fontspec }
        \setmainfont
          [
            Ligatures      = TeX,
            BoldFont       = timesbd.ttf,
            ItalicFont     = timesi.ttf,
            BoldItalicFont = timesbi.ttf
          ] { times.ttf }
        \setsansfont
          [
            Ligatures      = TeX,
            BoldFont       = arialbd.ttf,
            ItalicFont     = ariali.ttf,
            BoldItalicFont = arialbi.ttf
          ] { arial.ttf }
        \setmainjfont
          [
            Ligatures      = TeX,
            FontIndex      = 0,
            BoldFont       = HGRGE.TTC,
            ItalicFont     = msmincho.ttc,
            BoldItalicFont = HGRGE.TTC
          ] { msmincho.ttc }
        \setsansjfont
          [
            Ligatures      = TeX,
            FontIndex      = 0,
            BoldFont       = HGRGE.TTC,
            ItalicFont     = msgothic.ttc,
            BoldItalicFont = HGRGE.TTC
          ] { msgothic.ttc }
        \RequirePackage
          [
            mathrm=sym, mathup=sym, mathit=sym,
            mathsf=sym, mathbf=sym, mathtt=sym
          ] { unicode-math }
        \setmathfont [ FontIndex=1 ] { cambria.ttc }
      }
  }
% フォントサイズの設定
\RenewDocumentCommand\footnotesize {}
  { \fontsize{8bp}{12bp}\selectfont }
\RenewDocumentCommand\small {}
  { \fontsize{9bp}{13.5bp}\selectfont }
\RenewDocumentCommand\large {}
  { \fontsize{10.5bp}{15.75bp}\selectfont }
\RenewDocumentCommand\Large {}
  { \fontsize{12bp}{18bp}\selectfont }
\RenewDocumentCommand\LARGE {}
  { \fontsize{14bp}{21bp}\selectfont }
\RenewDocumentCommand\huge {}
  { \fontsize{16bp}{24bp}\selectfont }
