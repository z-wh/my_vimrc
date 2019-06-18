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

"------根据操作系统检测vim-plug是否存在,不存在自动下载-------
if WINDOWS()
"如果操作系统是Windows
    if has('nvim')
    "软件是neovim
        let vimplugPath=expand('~/AppData/Local/nvim/autoload/plug.vim')

        if !filereadable(vimplugPath)
            echo "Installing Vim-Plug..."
            silent !powershell md ~/AppData/Local/nvim/autoload; $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'; (New-Object Net.WebClient).DownloadFile($uri,$ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('~/AppData/Local/nvim/autoload/plug.vim'))
            autocmd VimEnter * PlugInstall
        endif

        let plugPath='~/AppData/Local/nvim/plugged'
    else
    "软件是vim
        "添加使用linux的插件安装目录
        set runtimepath+=~/.vim,~/.vim/after
        let vimplugPath=expand('~/.vim/autoload/plug.vim')
        
        if !filereadable(vimplugPath)
            echo "Installing Vim-Plug..."
            silent !powershell md ~\.vim\autoload; $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'; (New-Object Net.WebClient).DownloadFile($uri,$ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('~\.vim\autoload\plug.vim'))
            autocmd VimEnter * PlugInstall
        endif

        let plugPath=expand('~/.vim/plugged')
    endif

else
"操作系统不是Windows"
    if has('nvim')
    "软件是neovim
        let vimplugPath=expand('~/.local/share/nvim/site/autoload/plug.vim')

        if !filereadable(vimplugPath)
            echo "Installing Vim-Plug..."
            echo ""
            silent !\curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall
        endif

        let plugPath=expand('~/.local/share/nvim/plugged')
    else
    "软件是vim
        let vimplugPath=expand('~/.vim/autoload/plug.vim')

        if !filereadable(vimplugPath)
            echo "Installing Vim-Plug..."
            echo ""
            silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall
        endif

        let plugPath=expand('~/.vim/plugged')
    endif

endif

if !has('nvim')
    set nocompatible "去除和vi的一致,这样才能使用vim的加强功能
    let $LANG ='en' "设置为英语，因为utf-8导致中文乱码
    set langmenu=en
    set guioptions-=m "去除菜单
    set guioptions-=r "去除右滚动条
    set guioptions-=T "去除工具栏
    set guioptions-=L "去除左滚动条
endif

set number "显示行号

"encoding { try to set encoding to utf-8
    if WINDOWS()
        " Be nice and check for multi_byte even if the config requires
        " multi_byte support most of the time
        if has('multi_byte')
            " Windows cmd.exe still uses cp850. If Windows ever moved to
            " Powershell as the primary terminal, this would be utf-8
            set termencoding=cp850
            " Let Vim use utf-8 internally, because many scripts require this
            set encoding=utf-8
            setglobal fileencoding=utf-8
            " Windows has traditionally used cp1252, so it's probably wise to
            " fallback into cp1252 instead of eg. iso-8859-15.
            " Newer Windows files might contain utf-8 or utf-16 LE so we might
            " want to try them first.
            set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
        endif

    else
        " set default encoding to utf-8
        set encoding=utf-8
        set termencoding=utf-8
    endif
    scriptencoding utf-8
"}

"backup { 设置历史撤销记录、备份文件和交换存储文件的统一保存目录
    set backup "保存备份
    set undofile "保存撤销历史记录
    " setup back and swap directory
    let data_dir = $HOME.'/.data/'
    let backup_dir = data_dir . 'backup'
    let swap_dir = data_dir . 'swap'
    let undo_dir = data_dir . 'undo'
    if finddir(data_dir) == ''
        silent call mkdir(data_dir)
    endif
    if finddir(backup_dir) == ''
        silent call mkdir(backup_dir)
    endif
    if finddir(swap_dir) == ''
        silent call mkdir(swap_dir)
    endif
    if finddir(undo_dir) == ''
        silent call mkdir(undo_dir)
    endif
    unlet backup_dir
    unlet swap_dir
    unlet data_dir
    unlet undo_dir

    set backupdir=$HOME/.data/backup " where to put backup file
    set directory=$HOME/.data/swap " where to put swap file
    set undodir=$HOME/.data/undo "设置撤销记录文件存放目录
"}

set showcmd "右下角显示未完成的命令
set wildmenu "显示状态栏提示cmd命令
"高亮光标所在行
set cursorline
"高亮光标所在列
set cursorcolumn
"设置空白字符的视觉提示
set list listchars=extends:❯,precedes:❮,tab:\|\ ,trail:˽
"高亮搜索到的词
set hlsearch
"在查找模式输入完前显示匹配到的词
set incsearch
"设置更新时间
set updatetime=100
"在插入模式下 <BS> 如何删除光标前面的字符。
"逗号分隔的三个值分别指：行首的空白字符，分行符和插入模式开始处之前的字符。
set backspace=indent,eol,start
set history=200
"set cmdheight=2

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

" set default guifont {
    if has('gui_running')
        augroup ex_gui_font
            " check and determine the gui font after GUIEnter.
            " NOTE: getfontname function only works after GUIEnter.
            au!
            au GUIEnter * call s:set_gui_font()
        augroup END

        " set guifont
        function! s:set_gui_font()
            if has('nvim')
                "GuiFont Consolas:h14
            else
                if has('gui_gtk2')
                    if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
                    elseif getfontname( 'DejaVu Sans Mono' ) != ''
                        set guifont=DejaVu\ Sans\ Mono\ 12
                    else
                        set guifont=Luxi\ Mono\ 12
                    endif
                elseif has('x11')
                    " Also for GTK 1
                    set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
                elseif OSX()
                    if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h15
                    elseif getfontname( 'DejaVu Sans Mono' ) != ''
                        set guifont=DejaVu\ Sans\ Mono:h15
                    endif
                elseif WINDOWS()
                    if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14:cANSI
                    elseif getfontname( 'DejaVu Sans Mono' ) != ''
                        set guifont=DejaVu\ Sans\ Mono:h14:cANSI
                    elseif getfontname( 'Consolas' ) != ''
                        set guifont=Consolas:h14:cANSI " this is the default visual studio font
                    else
                        set guifont=Lucida_Console:h14:cANSI
                    endif
                endif
            endif
        endfunction

    endif
"}

"------------快捷键映射------------------------------
"mapping {
    if !has('nvim')
        "插入模式下移动快捷键映射
        "放在最上面M键映射不成功，放下面才能映射成功
        inoremap <M-h> <Left>
        inoremap <M-l> <Right>
        inoremap <M-k> <Up>
        inoremap <M-j> <Down>
    endif

    inoremap " ""<ESC>i
    inoremap { {}<ESC>i
    inoremap {<CR> {<CR>}<ESC>O
    inoremap ' ''<ESC>i
    inoremap [ []<ESC>i
    inoremap ( ()<ESC>i
"}

"--------------------定义文件夹路径变量---------------------------
"let pyt3_path= 'C:\Users\Administrator\AppData\Local\Programs\Python\Python37\python.exe'

"---------------vim-plug管理配置插件开始--------------------------
call plug#begin(plugPath)
unlet plugPath

"----------------------颜色主题-------------------------------
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

"----------------------airline--------------------------------
"airline {
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline#extensions#tabline#enabled = 1
"}

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
        "let g:python3_host_prog=pyt3_path
        "unlet pyt3_path
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
function DownLCBin()
    if LINUX()
        echo 'this is Linux'
        bash install.sh
    elseif WINDOWS()
        echo 'this is windows'
        powershell -executionpolicy bypass -File install.ps1
endfunction 
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': function ('DownLCBin')
        \ }
    set hidden "不用保存也能切换buffer"
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

   "php lsp { 
    Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}
    "}
"}

"ncm2 source {
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-tagprefix'
    Plug 'jsfaint/gen_tags.vim'
    Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'
    Plug 'ncm2/ncm2-neoinclude' | Plug 'Shougo/neoinclude.vim'
    Plug 'yuki-ycino/ncm2-dictionary'
    Plug 'ncm2/ncm2-cssomni'
    Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}
    Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'
    Plug 'ncm2/ncm2-html-subscope'
    Plug 'ncm2/ncm2-markdown-subscope'

    "snips {
        Plug 'ncm2/ncm2-ultisnips'
        Plug 'SirVer/ultisnips'
        Plug 'honza/vim-snippets' "代码片断集

        " Press enter key to trigger snippet expansion
        " The parameters are the same as `:help feedkeys()`
        inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

        " c-j c-k for moving in snippet
        let g:UltiSnipsExpandTrigger = "<c-z>"
        let g:UltiSnipsJumpForwardTrigger = "<c-j>"
        let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
        let g:UltiSnipsRemoveSelectModeMappings = 0
    "}

    "ncm2-match-highlight {高亮匹配项插件
        if !has('nvim')
            Plug 'ncm2/ncm2-match-highlight'
            let g:ncm2#match_highlight = 'double-struck'
        endif
    "}
"}

"----------------YouCompleteMe--------------------------------
"if !has('nvim')
function! BuildYCM(info) 
    " info is a dictionary with 3 fields  
    " - name:   name of the plugin  
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!  
    if a:info.status == 'installed' || a:info.force
        if LINUX()
            !./install.py --all
        elseif WINDOWS()
            ./pyhon3 install.py --all
    endif
endfunction

    Plug 'Valloric/YouCompleteMe', {'dir': '~/YouCompleteMe', 'do': function('BuildYCM') }
"endif

"----------------------------------taglist-------------------------------
Plug 'majutsushi/tagbar'

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
	\		'html': 0,
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
"}

"vim-gitgutter {
    if has('nvim')
        Plug 'airblade/vim-gitgutter'
    else
        "Plug 'airblade/vim-gitgutter'
        "let g:gitgutter_async=0 "不设置此项会导致整个文件标记为添加
        "vim-signify {
            Plug 'mhinz/vim-signify'
        "}
    endif
"}

"gist {
    "gist-vim {
        Plug 'mattn/webapi-vim'
        Plug 'mattn/gist-vim'
    "}
"}

"--------------------------终端命令异步执行-----------------------------
Plug 'skywind3000/asyncrun.vim'

call plug#end()
"-------------------vim-plug管理配置插件结束----------------------------

