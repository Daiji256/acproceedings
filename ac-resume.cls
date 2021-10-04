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

% オプションを指定して jlreq を読み込む
\LoadClass
  [
    paper=a4,
    fontsize=10bp,
    baselineskip=15bp,
    twocolumn,
    column_gap=7.5mm,
    line_length=23zw,
    number_of_lines=47
  ] { jlreq }
