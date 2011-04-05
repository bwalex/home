" Vim Compiler File
" Compiler:	Hugs98
" Maintainer:	Claus Reinke <C.Reinke@ukc.ac.uk>
" Last Change:	25 July 2002

" ------------------------------ paths & quickfix settings first
"

if exists("current_compiler") && current_compiler == "hugs"
  finish
endif
let current_compiler = "hugs"

" okay, let's go searching for that executable..
" try to set path and makeprg (for quickfix mode) as well
"
if has("win32")
  if executable("C:\\Program\ Files\\Hugs98\\hugs")
    setlocal makeprg=echo\ :q\ \\\|\ C:\\Program\ Files\\Hugs98\\hugs\ -98\ % 
    let g:haskell_path = "C:\\Program\\ Files\\Hugs98\\"
  elseif executable("C:\\Programme\\Hugs98\\hugs")
    setlocal makeprg=echo\ :q\ \\\|\ C:\\Programme\\Hugs98\\hugs\ -98\ % 
    let g:haskell_path = "C:\\Programme\\Hugs98\\"
  endif
endif

if has("unix") && isdirectory("/usr/local/share/hugs")
  set path+=/usr/local/share/hugs/lib/**
elseif has("win32") && exists("g:haskell_path") && g:haskell_path != ""
  execute "set path+=".escape(g:haskell_path,'\ ')."lib\\\\**"
endif

if executable("hugs")
  setlocal makeprg=echo\ :q\ \\\|\ hugs\ -98\ % 
  let g:haskell_path = ""
endif

if exists("g:haskell_path") " gotcha!
  let g:haskell=g:haskell_path."hugs -98 "
else
  echo "sorry, can't find Hugs98 - please set path by hand!"
  finish
endif

" quickfix mode: how to extract information from Hugs responses
"
setlocal errorformat=%+E%.%#ERROR\ \"%f\":%l\ -\ %m,
                    \%+E%.%#ERROR\ \"%f\"\ (line\ %l):\ %m,
                    \%+E%.%#ERROR%m,
                    \%+C***\ %m,
                    \%Z\\s%#,
                    \%-G\|%m,
                    \%-G_%m,
                    \%-G\\s%#,
                    \%-GReading%m,
                    \%-GParsing%m,
                    \%-GCompiling%m,
                    \%-GHugs\ Session%m,
                    \%-GType%m,
                    \%-G%.%#Leaving\ Hugs%.%#


" ------------------------- but hugs can do a lot more for us..
"
if exists("g:haskell_functions")
"  finish
endif
let g:haskell_functions = "hugs"

" avoid hit-enter prompts
set cmdheight=3

" os-specific external tools, and hugs editor settings
if has("win32")
  let s:grep="find"
  let s:ngrep="find /v"
  let s:esc='<>%'
  let s:editor=""
else
  let s:grep="grep"
  let s:ngrep="grep -v"
  let s:esc='$<>()'
  let s:editor="-E\"xterm -e vim +%d %s\" "
  " let s:editor="-E\"gvim +%d %s\" "
endif

" ------------------------------  for insert-mode completion
" (and to make gf work on imported modules)
set include=^import
set includeexpr=substitute(v:fname,\"$\",\".hs\",\"\")

" ------------------------------------------ key bindings
" browse current (_B,_e) or imported module (_i)
" insert resulting type infos as comment at top of file (_b)
" or as module export header (_e)
" or as module import list (_i)
" insert type declaration in new line before current (_t)
" find definition of current selection (_f)
map _i 0/[A-Z]/<CR>:noh<CR>"bye:call Browse(@b)<CR>$a ( )"bP:call Format()<CR>
map _B :call Browse("")<CR>:call New()<CR>"bP
map _b :call Browse("")<CR>1GO{--}1G"bp
map _e :call Browse("")<CR>1G:call Module()<CR>1GwgUl"bp:call Format()<CR>
map _I 0/[A-Z]/<CR>:noh<CR>"bye:call Browse(@b)<CR>:call New()<CR>"bp
map _t "ty:call AddTypeDecl(@t)<CR>
map _T "ty:call ShowType(@y)<cr>
map _f "fy:call Find(@f)<CR>

" --------------------------------------------------- menus
if has("menu")
  if exists("b:haskell_menu")
    aunmenu Haskell(Hugs98)
  endif

  100amenu Haskell(Hugs98).-Change-                    :
  amenu Haskell(Hugs98).AddImportDecls<tab>_i       _i
  amenu Haskell(Hugs98).AddModuleHeader<tab>_e      _e
  amenu Haskell(Hugs98).AddTypeDecl<tab>{visual}_t  :call AddTypeDecl(expand("<cword>"))<cr>
  amenu Haskell(Hugs98).-Browse-                    :
  amenu Haskell(Hugs98).BrowseCurrent<tab>_B        _B
  amenu Haskell(Hugs98).BrowseImport<tab>_I         _I
  amenu Haskell(Hugs98).ShowType                    :call ShowType(expand("<cword>"))<cr>
  amenu Haskell(Hugs98).ShowInfo                    :call ShowInfo(expand("<cword>"))<cr>
  amenu Haskell(Hugs98).FindDecl<tab>{visual}_f     viw_f
  amenu Haskell(Hugs98).DeclarationsMenu            :call DeclarationsMenu()<cr>
  amenu Haskell(Hugs98).-Set\ Options-              :
  amenu Haskell(Hugs98).ToggleAutoType(off)         :call ToggleAutoType()<cr>
  let b:haskell_menu = "yes"

  " update delarations menu
  " au BufRead *.hs nested call DeclarationsMenu()
  " au BufWritePost *.hs nested call DeclarationsMenu()

  " create a menu with all declarations in current module,
  " as returned by browse (Problem: how to locate the items?
  " LocalFind is unreliable, Find tends to open new windows..)
  function! DeclarationsMenu()
    if exists("b:haskell_declarations_menu")
      aunmenu Declarations
    endif
    110amenu Declarations.Refresh :call DeclarationsMenu()<cr>
    let output = Browse("")
    while output != ""
      let line   = matchstr(output,"^[^\n]\*\n")
      let output = substitute(output,"^[^\n]*\n","","")
      let ident  = matchstr(line,'\S\+')
      let menuitem = "amenu Declarations.".ident.' :call LocalFind("'.ident.'")<cr>'
      "let menuitem = "amenu Declarations.".ident.' :call Find("'.ident.'")<cr>'
      execute menuitem
    endwhile
    let b:haskell_declarations_menu = "yes"
  endfunction

  " try to locate a definition in the current file, without
  " asking hugs to start another editor instance
  " todo: literate style with \begin{code} .. :-(
  function! LocalFind(what)
    let literate = fnamemodify(expand("%"),":e") == "lhs"
    normal 1G
    let pat  = '\<'.a:what.'\>'
    if literate
      let line = search('^>\s\*'.pat)
    else
      let line = search('^'.pat)
    endif
    if line == 0
      call search(pat)
    endif
    nohlsearch
  endfunction
endif

" automatic type info, don't update too often while each call 
" goes to a fresh haskell interpreter.. can be irritating, so 
" default is off
let s:autotype = "off"
function! ToggleAutoType()
  if s:autotype == "on"
    au! CursorHold
    let s:autotype = "off"
    aunmenu Haskell(Hugs98).ToggleAutoType(on)
    amenu Haskell(Hugs98).ToggleAutoType(off) :call ToggleAutoType()<cr>
  else
    set updatetime=3000
    au CursorHold *.hs nested call ShowType(expand("<cword>"))
    let s:autotype = "on"
    aunmenu Haskell(Hugs98).ToggleAutoType(off)
    amenu Haskell(Hugs98).ToggleAutoType(on) :call ToggleAutoType()<cr>
  endif
endfunction

" if I ever figure out how to create a hidden buffer,
" we could replace the automatic type-info with a lookup
" there (as in the emacs haskell mode). would be a lot more
" efficient/useable.. we'd need to keep the buffer updated 
" and it would have to include type declarations for
" all imported modules, too.
function! ShowDeclType(thing)
  if a:thing != ""
    let thisModule = fnamemodify(expand("%"),":t:r")
    let name       = thisModule . "-Types"
    let thisbnr    = bufnr("%")
    let thatbnr    = bufnr(name)
    execute "buffer ".thatbnr
    let lnr  = search(a:thing)
    let line = getline(lnr)
    execute "buffer ".thisbnr
    echo line
  endif
endfunction

" show type declaration of thing, as given by haskell interpreter
"
function! ShowType(thing)
  if a:thing != ""
    echo "------------------------------"
    echo Type("echo :t","(".a:thing.")"," | ".s:grep." \"::\"") 
  endif
endfunction

" show info for thing, as given by haskell interpreter
"
function! ShowInfo(thing)
  if a:thing != ""
    echo "------------------------------"
    echo Type("echo :i",a:thing," | ".s:ngrep." \"Leaving Hugs\"") 
  endif
endfunction

" add new line with type dec, as given by haskell interpreter
"
function! AddTypeDecl(thing)
  if a:thing != ""
    call Type("echo :t","(".a:thing.")"," | ".s:grep." \"::\"") 
    put! t
  endif
endfunction

" ask about type of/info for current selection
" cmd:      "echo :i" or "echo :t"
" thing:    the selection
" postcmd:  typically a filter
"
function! Type(cmd,thing,postcmd)
  let output=system(a:cmd.escape(" ".a:thing,s:esc)." | ".g:haskell.expand("%").a:postcmd)
  let output=substitute(output,"[^>]*> ","","")
  let @t = output
  return output
endfunction

" load current file into Hugs98,
" and use its editor-binding to invoke an editor on the definition
" of the current selection (you'll prefer to set the editor in Hugs,
" or you can set s:editor in this script)
"
function! Find(what)
  let haskellCmd="echo :f "
  call system(haskellCmd.escape(a:what,s:esc)." | ".g:haskell.s:editor.expand("%"))
endfunction

" create a new scratch buffer
"
function! New()
  new
  set buftype=nofile
  set bufhidden=delete
  set noswapfile
endfunction

" invoke the haskell interpreter's browse function
"
function! Browse(module)
  let haskellCmd="echo :browse ".a:module." "
  let output=system(haskellCmd." | ".g:haskell.expand("%")." | ".s:grep." \"::\"")
  if a:module == ""
    let output=substitute(output,"^[^>]*> ","","")
  endif
  let @b=substitute(output,"^\s*\n","","")
  return @b
endfunction

" create default module header from current file name
"
function! Module()
  call append(0,"")
  call append(0," ) where")
  call append(0,"module ".fnamemodify(expand("%"),":t:r")." (")
endfunction

" format the results of :browse for use in import/export lists
"
function! Format()
  let m=0
  let l0 = line(".")
  let l=l0
  let m1=stridx(getline(l),"::")
  while m1 > -1
    if m1 > m
      let m=m1
    endif
    let l=l+1
    let m1=stridx(getline(l),"::")
  endw
  let l=l0
  let m1=stridx(getline(l),"::")
  while m1 > -1
    if l>l0
      let prefix = " ,"
    else
      let prefix = "  "
    endif
    call setline(l,prefix.substitute(getline(l),"::",X(m-m1," ")."-- ::",""))
    let l=l+1
    let m1=stridx(getline(l),"::")
  endw
endfunction

" return n copies of s
"
function! X(n,s)
  let r=""
  let c=a:n
  while c > 0
    let r=r.a:s
    let c=c-1
  endw
  return r
endfunction

