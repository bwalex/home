" vim: tw=0 ts=4 sw=4
" Vim color file

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "2c"

hi Normal														guifg=#dddddd guibg=black
hi Comment		term=bold		ctermfg=DarkCyan				guifg=DarkCyan
hi Constant		term=underline	cterm=bold ctermfg=Magenta		guifg=Magenta
hi Special		term=bold		cterm=bold ctermfg=Red			guifg=#ff7070 gui=bold
hi Identifier	term=underline	cterm=bold ctermfg=Cyan			guifg=Cyan gui=bold
hi Statement	term=bold		cterm=bold ctermfg=white		guifg=white gui=bold
hi Label		term=underline	ctermfg=red						guifg=red
hi PreProc		term=underline	cterm=bold ctermfg=Blue			guifg=#5555ff gui=bold
hi Type			term=underline	cterm=bold ctermfg=Green		guifg=Green gui=bold
hi Function		term=bold		cterm=bold ctermfg=cyan			guifg=cyan gui=bold
hi Repeat		term=underline	cterm=bold ctermfg=White		guifg=white gui=bold
hi Operator						cterm=bold ctermfg=yellow		guifg=yellow gui=bold
hi Ignore						ctermfg=black					guifg=bg
hi Error		term=reverse	ctermbg=Red ctermfg=White		guibg=Red guifg=White
hi Todo			term=standout	ctermbg=Yellow ctermfg=Black	guifg=Blue guibg=Yellow
hi Visual		term=reverse	cterm=reverse					gui=reverse

hi link String			Constant
hi link Character		Constant
hi link Number			Constant
hi link Boolean			Constant
hi link Float			Number
hi link Conditional		Repeat
hi link Label			Statement
hi link Keyword			Statement
hi link Exception		Statement
hi link Include			PreProc
hi link Define			PreProc
hi link Macro			PreProc
hi link PreCondit		PreProc
hi link StorageClass	Type
hi link Structure		Type
hi link Typedef			Type
hi link Tag				Special
hi link SpecialChar		Special
hi link Delimiter		Special
hi link SpecialComment	Special
hi link Debug			Special
