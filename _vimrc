if !has('nvim')
    set nocompatible "去除和vi的一致兼容
    let $LANG ='en' "设置为英语，因为utf-8导致中文乱码
    set langmenu=en
    set guioptions-=m "去除菜单
    set guioptions-=r "去除右滚动条
    set guioptions-=T "去除工具栏
    set guioptions-=L "去除左滚动条
endif

"------------------------判断是什么操作系统------------------
function! OSX()
    return has('macunix')
endfunction
function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function! WINDOWS()
    return  (has('win16') || has('win32') || has('win64'))
endfunction

"将windows文件放置位置设成和linux一样
"方便配置文件多平台通用
if WINDOWS()
    if !has('nvim')
        set runtimepath+=$HOME/.vim,$HOME/.vim/after
    endif
endif

set nu "显示行号
set encoding=utf-8
"高亮光标所在行
set cursorline
"高亮光标所在列
set cursorcolumn
"设置空白字符的视觉提示
set list listchars=extends:❯,precedes:❮,tab:\|\ ,trail:˽
"设置更新时间
set updatetime=100

"----------------设置tab键宽度-------------------------------
"tabstop 表示按一个tab之后，显示出来的相当于几个空格，默认的是8个。
set tabstop=4
"softtabstop 表示在编辑模式的时候按退格键的时候退回缩进的长度。
set softtabstop=4
"shiftwidth 表示每一级缩进的长度，一般设置成跟 softtabstop 一样
set shiftwidth=4
"expandtab与noexpandtab 当设置成 expandtab 时，缩进用空格来表示，
"noexpandtab 则是用制表符表示一个缩进。
set expandtab

"-------------颜色主题设置---------------------------
if !has('gui_running')
    set t_Co=256 "设置终端256色
endif

set background=dark
colorscheme gruvbox
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14:cANSI "字体

"------------快捷键映射------------------------------
if !has('nvim')
    "插入模式下移动快捷键映射
    "放在最上面M键映射不成功，放下面才能映射成功
    inoremap <M-h> <ESC>h
    inoremap <M-l> <ESC>l
    inoremap <M-k> <ESC>k
    inoremap <M-j> <ESC>j
endif

inoremap " ""<ESC>i
inoremap { {}<ESC>i
inoremap {<CR> {<CR>}<ESC>O
inoremap ' ''<ESC>i
inoremap [ []<ESC>i
inoremap ( ()<ESC>i

"--------------------定义文件夹路径变量---------------------------
let pyt3_path= 'C:\Users\Administrator\AppData\Local\Programs\Python\Python36\python.exe'

"---------------vim-plug管理配置插件开始--------------------------
if has('nvim')
    call plug#begin($VIM.'/plugged')
else
    call plug#begin($VIM.'/vimfiles/plugged')
endif

"----------------------颜色主题-------------------------------
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

"----------------------airline--------------------------------
"airline {
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline#extensions#tabline#enabled = 1
"}

"----------------YouCompleteMe--------------------------------
if !has('nvim')
    Plug 'Valloric/YouCompleteMe'
endif

"----------------全屏插件---------------------------------
"fullscreen {
    if has('nvim')
        Plug 'lambdalisue/vim-fullscreen'
        let g:fullscreen#start_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 1)"
        let g:fullscreen#stop_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 0)"
    elseif has('win32') || has('win64')
        Plug 'zhmars/gvimtweak'
        let g:gvimtweak#window_alpha=240
        let g:gvimtweak#enable_alpha_at_startup=1
        nnoremap<silent> <F11> :GvimTweakToggleFullScreen<CR>
    endif
"}

"-----------------------ncm2:补全框架-------------------------
"ncm2 {
    Plug 'ncm2/ncm2'

    "nvim-yarp {
        Plug 'roxma/nvim-yarp'
        "指定python3的路径地址
        let g:python3_host_prog=pyt3_path
        unlet pyt3_path
    "}

    "vim 使用ncm2需要额外安装该插件支持
    if !has('nvim')
        Plug 'roxma/vim-hug-neovim-rpc'
    endif

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
    set hidden
    let g:LanguageClient_serverCommands = {
        \ 'javascript': ["node","C:/Users/Administrator/AppData/Roaming/npm/node_modules/lsp-tsserver/dist/server.js"],
        \ 'css': ["node", "C:/Users/Administrator/AppData/Roaming/npm/node_modules/vscode-css-languageserver-bin/cssServerMain.js", "--stdio"],
        \ 'scss': ["node", "C:/Users/Administrator/AppData/Roaming/npm/node_modules/vscode-css-languageserver-bin/cssServerMain.js", "--stdio"],
        \ }
    nnoremap <F5> :call LanguageClient_contextMenu()<CR>
    " Or map each action separately
    nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

    " (Optional) Multi-entry selection UI.
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
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
        if !has('nvim')
            Plug 'ncm2/ncm2-match-highlight'
            let g:ncm2#match_highlight = 'double-struck'
        endif
    "}
"}

"----------------------------------taglist-------------------------------
Plug 'vim-scripts/taglist.vim'

"----------------------------------html插件------------------------------
"html {
    Plug 'othree/html5.vim'

    "----------emmet----------
    Plug 'mattn/emmet-vim'

    "-----css颜色显示插件-----
    Plug 'ap/vim-css-color'

    "--------html css js格式化插件-------
    "vim-jsbeautify {
        Plug 'maksimr/vim-jsbeautify'
        "for js
        autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
        autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
        " for json
        autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
        autocmd FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
        " for jsx
        autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
        autocmd FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
        " for html
        autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
        autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
        " for css or scss
        autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
        autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>
    "}
"}
"----------------------------注释插件------------------------------------
Plug 'scrooloose/nerdcommenter'

"----------------------------多语言格式化插件----------------------------
Plug 'Chiel92/vim-autoformat'

"vim-easy-align {
    Plug 'junegunn/vim-easy-align'
    " start interactive easyalign in visual mode (e.g. vipga)
    xmap ga <plug>(easyalign)
    " start interactive easyalign for a motion/text object (e.g. gaip)
    nmap ga <plug>(easyalign)
"}

"rainbow { 彩虹括号
    Plug 'luochen1990/rainbow'
    let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
    let g:rainbow_conf = {
	\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'tex': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\		},
	\		'lisp': {
	\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\		},
	\		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}
"}

"-------------------------------代码检查插件-----------------------------
"Asynchronous Lint Engine {
    Plug 'w0rp/ale'
    let g:airline#extensions#ale#enableed=1
    "自定义error和warning图标
    let g:ale_sign_error = '✗'
    let g:ale_sign_warning = '⚡'
    "显示Linter名称,出错或警告等相关信息
    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"}

"----------------------------多行游标------------------------------------
Plug 'terryma/vim-multiple-cursors'

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

"------------------------------搜索增强----------------------------------
Plug 'ctrlpvim/ctrlp.vim'

"-----------------------git,gitgutter,gitst------------------------------
"git {
    Plug 'tpope/vim-fugitive'
    if has('nvim')
        "vim-gitgutter {
            Plug 'airblade/vim-gitgutter'
        "}
    else
        "vim-gitgutter {
            Plug 'airblade/vim-gitgutter'
            let g:gitgutter_async=0 "不设置此项会导致整个文件标记为添加
        "}
        "Plug 'mhinz/vim-signify'
    endif

    "gist {
        "gist-vim {
            Plug 'mattn/webapi-vim'
            Plug 'mattn/gist-vim'
        "}
    "}
"}

"--------------------------终端命令异步执行-----------------------------
Plug 'skywind3000/asyncrun.vim'

call plug#end()
"-------------------vim-plug管理配置插件结束----------------------------

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
