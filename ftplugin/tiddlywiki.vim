" Vim filetype plugin for TiddlyWiki
" Language: tiddlywiki
" Maintainer: Devin Weaver <suki@tritarget.org>
" License: http://www.apache.org/licenses/LICENSE-2.0.txt

let s:save_cpo = &cpo
set cpo-=C

" *.md.meta -> *.md jump
nnoremap <leader>ec :e %:p:r:r.md<CR>

function! TiddlyWikiTime()
  return strftime('%Y%m%d%H%M%S')
endfunction

function! s:UpdateModifiedTime()
  let save_cursor = getcurpos()
  silent 0,/^\s*$/global/^modified: / delete
  call append(0, "modified: " . TiddlyWikiTime())
  call setpos('.', save_cursor)
endfunction

function! s:AutoUpdateModifiedTime()
  if &modified
    call <SID>UpdateModifiedTime()
  endif
endfunction

function! s:InitializeTemplate()
  let timestamp = TiddlyWikiTime()
  call append(0, "modified: " . timestamp)
  call append(1, "created: " . timestamp)
  call append(2, "modifier: ")
  call append(3, "creator: ")
  call append(4, "title: " . expand('%:t:r:r'))
  call append(5, "tags: ")
  call append(6, "type: text/x-markdown")
endfunction

if line('$') == 1 && getline(1) == ''
  call s:InitializeTemplate()
endif

augroup tiddlywiki
  au!
  au BufWrite <buffer> call <SID>AutoUpdateModifiedTime()
augroup END

let &cpo = s:save_cpo