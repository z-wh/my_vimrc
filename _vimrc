set nocompatible
let $LANG ='en'
set langmenu=en
if !has('nvim')
  source $VIMRUNTIME/vimrc_example.vim
endif
set guioptions-=m
set guioptions-=r
set guioptions-=T
set guioptions-=L
set nu
set encoding=utf-8
set cursorline "高亮光标所在行
set cursorcolumn "高亮光标所在列
"----------------设置tab键宽度-------------------------------
"tabstop 表示按一个tab之后，显示出来的相当于几个空格，默认的是8个。 
" softtabstop 表示在编辑模式的时候按退格键的时候退回缩进的长度。 
" shiftwidth 表示每一级缩进的长度，一般设置成跟 softtabstop 一样 
" expandtab与noexpandtab 当设置成 expandtab 时，缩进用空格来表示，noexpandtab 则是用制表符表示一个缩进。个人习惯使用 ｀set expandtab｀ 
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
"-------------solarized颜色主题设置---------------------------
set background=dark
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14
colorscheme solarized

call plug#begin('e:/zwh/software/vim/vimfiles/plugged')
"----------------------颜色主题-------------------------------
Plug 'altercation/vim-colors-solarized'

if !has('nvim')
"----------------YouCompleteMe--------------------------------
Plug 'Valloric/YouCompleteMe'
endif

"----------------全屏透明插件---------------------------------
"guimtweak {
  Plug 'zhmars/gvimtweak'
  " alpha value (180 ~ 255) default: 245
  let g:gvimtweak#window_alpha=240
  " enable alpha at startup
  let g:gvimtweak#enable_alpha_at_startup=1
  " enable topmost at startup
  let g:gvimtweak#enable_topmost_at_startup=0
  " enable maximize at startup
  let g:gvimtweak#enable_maximize_at_startup=0
  " enable fullscreen at startup
  let g:gvimtweak#enable_fullscreen_at_startup=0
  " nnoremap<silent> <A-k> :GvimTweakSetAlpha 10<CR>
  " nnoremap<silent> <A-j> :GvimTweakSetAlpha -10<CR>
  " nnoremap<silent> <A-t> :GvimTweakToggleTopMost<CR>
  " nnoremap<silent> <A-m> :GvimTweakToggleMaximize<CR>
  " nnoremap<silent> <A-f> :GvimTweakToggleFullScreen<CR>
  nnoremap<silent> <F11> :GvimTweakToggleFullScreen<CR>
"}

"-------------------ncm2:补全框架依赖上面两个yarp rpc插件----------------
"ncm2 {
  Plug 'ncm2/ncm2'

  Plug 'roxma/nvim-yarp'
  "指定python3的路径地址
  let g:python3_host_prog =  'C:\Users\Administrator\AppData\Local\Programs\Python\Python36\python.exe'

  Plug 'roxma/vim-hug-neovim-rpc'
  " enable ncm2 for all buffers
  autocmd BufEnter * call ncm2#enable_for_buffer()
  
  " IMPORTANTE: :help Ncm2PopupOpen for more information
  set completeopt=noinsert,menuone,noselect
  
   " suppress the annoying 'match x of y', 'The only match' and 'Pattern not
   " found' messages
   set shortmess+=c
  
   " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
   inoremap <c-c> <ESC>
  
   " When the <Enter> key is pressed while the popup menu is visible, it only
   " hides the menu. Use this mapping to close the menu and also start a new
   " line.
   inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
  
   " Use <TAB> to select the popup menu:
   inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
   inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  
   " wrap existing omnifunc
   " Note that omnifunc does not run in background and may probably block the
   " editor. If you don't want to be blocked by omnifunc too often, you could
   " add 180ms delay before the omni wrapper:
   "  'on_complete': ['ncm2#on_complete#delay', 180,
   "               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
   au User Ncm2Plugin call ncm2#register_source({
           \ 'name' : 'css',
           \ 'priority': 9, 
           \ 'subscope_enable': 1,
           \ 'scope': ['css','scss'],
           \ 'mark': 'css',
           \ 'word_pattern': '[\w\-]+',
           \ 'complete_pattern': ':\s*',
           \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
           \ })
"}

"Language Server Protocol {
  Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'powershell -executionpolicy bypass -File install.ps1'
      \ }
  " (Optional) Multi-entry selection UI.
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  set hidden
  let g:LanguageClient_serverCommands = {
      \ 'javascript': ["node","C:/Users/Administrator/AppData/Roaming/npm/node_modules/lsp-tsserver/dist/server.js"],
      \ 'css': ["node", "C:/Users/Administrator/AppData/Roaming/npm/node_modules/vscode-css-languageserver-bin/cssServerMain.js", "--stdio"],
      \ }
  nnoremap <F5> :call LanguageClient_contextMenu()<CR>
  " Or map each action separately
  nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
  nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
  nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
"}

"ncm2 source {
  Plug 'ncm2/ncm2-bufword'
  Plug 'ncm2/ncm2-path'
  Plug 'ncm2/ncm2-tagprefix'
  Plug 'jsfaint/gen_tags.vim'
  Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
  Plug 'yuki-ycino/ncm2-dictionary'
  Plug 'ncm2/ncm2-cssomni'
  Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}
  Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'
  Plug 'ncm2/ncm2-html-subscope'

  "vim-snipmate {
    "代码片断插件
    Plug 'ncm2/ncm2-snipmate'
    " snipmate dependencies
    Plug 'tomtom/tlib_vim'
    Plug 'marcweber/vim-addon-mw-utils'
    Plug 'garbas/vim-snipmate'
    " Press enter key to trigger snippet expansion
    " The parameters are the same as `:help feedkeys()`
    inoremap <silent> <expr> <CR> ncm2_snipmate#expand_or("\<CR>", 'n')
    " wrap <Plug>snipMateTrigger so that it works for both completin and normal
    " snippet
    " inoremap <expr> <c-u> ncm2_snipmate#expand_or("\<Plug>snipMateTrigger", "m")
    " c-j c-k for moving in snippet
    let g:snips_no_mappings = 1
    vmap <c-j> <Plug>snipMateNextOrTrigger
    vmap <c-k> <Plug>snipMateBack
    imap <expr> <c-k> pumvisible() ? "\<c-y>\<Plug>snipMateBack" : "\<Plug>snipMateBack"
    imap <expr> <c-j> pumvisible() ? "\<c-y>\<Plug>snipMateNextOrTrigger" : "\<Plug>snipMateNextOrTrigger"
  "}
  
  "ncm2-match-highlight {高亮匹配项插件
    Plug 'ncm2/ncm2-match-highlight'
    let g:ncm2#match_highlight = 'bold'
    let g:ncm2#match_highlight = 'sans-serif'
    let g:ncm2#match_highlight = 'sans-serif-bold'
    let g:ncm2#match_highlight = 'mono-space'
    " default
    let g:ncm2#match_highlight = 'double-struck'
  "}
"}

"----------------------------------emmet---------------------------------
Plug 'mattn/emmet-vim'

"--------------------------文件浏览nerdtree------------------------------
"nerdtree {
  Plug 'scrooloose/nerdtree'
  nnoremap <leader>n :NERDTree<cr>
"}

"-------------------------------历史记录树-------------------------------
"undotree {
  Plug 'mbbill/undotree'
  nnoremap <leader>u :UndotreeToggle<cr>
"}

"--------------------------------格式化插件------------------------------
"vim-autoformat {
  Plug 'Chiel92/vim-autoformat'
  noremap <leader>f :Autoformat<cr>
"}
"------------------------------css颜色显示插件---------------------------
Plug 'ap/vim-css-color'

call plug#end()

if !has('nvim')
  set diffexpr=MyDiff()
  function! MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg1 = substitute(arg1, '!', '\!', 'g')
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg2 = substitute(arg2, '!', '\!', 'g')
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let arg3 = substitute(arg3, '!', '\!', 'g')
    if $VIMRUNTIME =~ ' '
      if &sh =~ '\<cmd'
        if empty(&shellxquote)
          let l:shxq_sav = ''
          set shellxquote&
        endif
        let cmd = '"' . $VIMRUNTIME . '\diff"'
      else
        let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
      endif
    else
     let cmd = $VIMRUNTIME . '\diff'
    endif
    let cmd = substitute(cmd, '!', '\!', 'g')
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
    if exists('l:shxq_sav')
      let &shellxquote=l:shxq_sav
    endif
  endfunction
endif

