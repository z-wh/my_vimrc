if !has('nvim')
    set nocompatible
    let $LANG ='en'
    set langmenu=en
    source $VIMRUNTIME/vimrc_example.vim
    "以下插入模式下移动快捷键映射
    "每次要重新加载一下才起效 ：source %
    "可能这个版本有问题
    inoremap <M-h> <ESC>h
    inoremap <M-l> <ESC>l
    inoremap <M-k> <ESC>k
    inoremap <M-j> <ESC>j
    set guioptions-=m
    set guioptions-=r
    set guioptions-=T
    set guioptions-=L
endif
if has('nvim')
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14:cANSI
else
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14:cANSI
endif
set nu
set encoding=utf-8
set cursorline "高亮光标所在行
set cursorcolumn "高亮光标所在列
"设置空白字符的视觉提示
set list listchars=extends:❯,precedes:❮,tab:\|\ ,trail:˽
"设置更新时间
set updatetime=100
"----------------设置tab键宽度-------------------------------
"tabstop 表示按一个tab之后，显示出来的相当于几个空格，默认的是8个。
"softtabstop 表示在编辑模式的时候按退格键的时候退回缩进的长度。
"shiftwidth 表示每一级缩进的长度，一般设置成跟 softtabstop 一样
"expandtab与noexpandtab 当设置成 expandtab 时，缩进用空格来表示，
"noexpandtab 则是用制表符表示一个缩进。
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
"-------------颜色主题设置---------------------------
set background=dark
colorscheme gruvbox

if has('nvim')
    call plug#begin('e:/zwh/software/Neovim/share/nvim/plugged')
else
    call plug#begin('e:/zwh/software/vim/vimfiles/plugged')
endif
"----------------------颜色主题-------------------------------
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

"----------------------airline--------------------------------
"airline {
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
"    let g:airline_theme='simple'
    let g:airline#extensions#tabline#enabled = 1
"    let g:airline#extensions#tabline#formatter = 'default'
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
        let g:python3_host_prog = 'C:\Users\Administrator\AppData\Local\Programs\Python\Python36\python.exe'
    "}

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
        \ 'scss': ["node", "C:/Users/Administrator/AppData/Roaming/npm/node_modules/vscode-css-languageserver-bin/cssServerMain.js", "--stdio"],
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
        "if !has('nvim')
            Plug 'ncm2/ncm2-match-highlight'
            let g:ncm2#match_highlight = 'double-struck'
        "endif
    "}
"}

"----------------------------------taglist-------------------------------
Plug 'vim-scripts/taglist.vim'

"----------------------------------emmet---------------------------------
Plug 'mattn/emmet-vim'

"------------------------------css颜色显示插件---------------------------
Plug 'ap/vim-css-color'

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

"------------------------------搜索--------------------------------------
Plug 'ctrlpvim/ctrlp.vim'

"-----------------------git,gitgutter,gitst------------------------------
"git {
    Plug 'tpope/vim-fugitive'
    if has('nvim')
        Plug 'airblade/vim-gitgutter'
    else
        Plug 'mhinz/vim-signify'
    endif

    "gist {
        Plug 'mattn/webapi-vim'
        Plug 'mattn/gist-vim'
    "}
"}



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

