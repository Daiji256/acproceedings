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
    japanese .default:n = true
  }
\ProcessKeysOptions { ac-resume / option }
\PassOptionsToClass { \g__acr_options_clist } { jlreq }

% オプションを指定して jlreq を読み込む
\LoadClass
  [
    paper=a4,
    fontsize=10bp,
    baselineskip=15bp,
    twocolumn,
    column_gap=7.5mm,
    line_length=23zw,
    number_of_lines=47,
    \bool_if:NF \g_acr_nogutter_bool { gutter=2cm }
  ] { jlreq }

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

\tl_set:Nn \indexname { 参考文献 }
\cs_set:Npn \@biblabel #1 { #1) }

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
    { \huge\bfseries \g_acr_title_jp: \\[1mm] }
    { \LARGE\bfseries \g_acr_title_en: \\[5mm] }
    { \Large\bfseries \g_acr_author_jp:（\g_acr_author_en:） \\[5mm] }
    { \normalsize\sffamily \g_acr_major:（\g_acr_supervisor:） \\[7mm] }
    \begin{minipage}{150mm}
      \setlength{\parindent}{1\zw}
      { \small \g_acr_abstract: \\[5mm]}
      { \small \noindent { \bfseries Keywords:~ } \g_acr_keywords: \\[2mm] }
    \end{minipage}
  }

\sys_if_engine_ptex:T
  {
    \RequirePackage [ utf8 ] { inputenc }
    \RequirePackage [ T1 ] { fontenc }
    \RequirePackage [ deluxe ] {otf}
    \RequirePackage [ noalphabet ] { pxchfon }
    \setmediumminchofont { HaranoAjiMincho-Light.otf }
    \setboldminchofont   { HaranoAjiMincho-Medium.otf }
    \setmediumgothicfont { HaranoAjiGothic-Medium.otf }
    \setboldgothicfont   { HaranoAjiGothic-Bold.otf }
    \DeclareFontShape { JY1 } { hmc } { b } { n } { <->ssub*hmc/bx/n } {}
    \DeclareFontShape { JT1 } { hmc } { b } { n } { <->ssub*hmc/m/n }  {}
    \DeclareFontShape { JY1 } { hgt } { b } { n } { <->ssub*hgt/bx/n } {}
    \DeclareFontShape { JT1 } { hgt } { b } { n } { <->ssub*hgt/m/n }  {}
    \RequirePackage { newtxtext, newtxmath }
    \RequirePackage { helvet }
  }
\sys_if_engine_uptex:T
  {
    \RequirePackage [ T1 ] { fontenc }
    \RequirePackage [ deluxe, uplatex ] {otf}
    \RequirePackage [ noalphabet ] { pxchfon }
    \setmediumminchofont { HaranoAjiMincho-Light.otf }
    \setboldminchofont   { HaranoAjiMincho-Medium.otf }
    \setmediumgothicfont { HaranoAjiGothic-Medium.otf }
    \setboldgothicfont   { HaranoAjiGothic-Bold.otf }
    \DeclareFontShape { JY2 } { hmc } { b } { n } { <->ssub*hmc/bx/n } {}
    \DeclareFontShape { JT2 } { hmc } { b } { n } { <->ssub*hmc/m/n }  {}
    \DeclareFontShape { JY2 } { hgt } { b } { n } { <->ssub*hgt/bx/n } {}
    \DeclareFontShape { JT2 } { hgt } { b } { n } { <->ssub*hgt/m/n }  {}
    \RequirePackage { newtxtext, newtxmath }
    \RequirePackage { helvet }
  }
\sys_if_engine_luatex:T
  {
    \RequirePackage [ T1 ] { fontenc }
    \RequirePackage { luatexja-fontspec }
    \setmainjfont
      [
        Ligatures      = TeX,
        BoldFont       = HaranoAjiMincho-Medium.otf,
        ItalicFont     = HaranoAjiMincho-Light.otf,
        BoldItalicFont = HaranoAjiMincho-Medium.otf
      ] { HaranoAjiMincho-Light.otf }
    \setsansjfont
      [
        Ligatures      = TeX,
        BoldFont       = HaranoAjiGothic-Bold.otf,
        ItalicFont     = HaranoAjiGothic-Medium.otf,
        BoldItalicFont = HaranoAjiGothic-Bold.otf
      ] { HaranoAjiGothic-Medium.otf }
    \RequirePackage { newtxtext, newtxmath }
    \RequirePackage { helvet }
  }

% フォントサイズの設定（jlreq 内部のコマンドを使用している）
\RenewDocumentCommand\footnote {}
  { \@setfontsize\footnote{8bp}{\jlreq@baselineskip} }
\RenewDocumentCommand\small {}
  { \@setfontsize\small{9bp}{\jlreq@baselineskip} }
\RenewDocumentCommand\large {}
  { \@setfontsize\large{10.5bp}{\jlreq@baselineskip} }
\RenewDocumentCommand\Large {}
  { \@setfontsize\Large{12bp}{\jlreq@baselineskip} }
\RenewDocumentCommand\LARGE {}
  { \@setfontsize\LARGE{14bp}{\jlreq@baselineskip} }
\RenewDocumentCommand\huge {}
  { \@setfontsize\huge{16bp}{\jlreq@baselineskip} }

% section 等の設定
\ModifyHeading { section }
  {
    font={\large\sffamily\bfseries},
    align=center,
    label_format={\thesection .},
    after_label_space=1\zw,
    lines=1,
    before_lines=1,
    after_lines=1
  }
\ModifyHeading { subsection }
  {
    font={\sffamily\bfseries},
    label_format={\thesubsection .},
    after_label_space=1\zw,
    lines=1,
    before_lines=1
  }
\ModifyHeading { subsubsection }
  {
    font={\sffamily\bfseries},
    label_format={\thesubsubsection .},
    after_label_space=1\zw,
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
\NewPageStyle { ac-pagestyle } { nombre=\large\g_acr_program:-\thepage }
\pagestyle{ac-pagestyle}

% 参考文献（フォントサイズを small に変更）
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
