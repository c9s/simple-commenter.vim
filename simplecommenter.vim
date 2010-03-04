" Simple Commenter
"   Support most file type.
"   Depends on 'commentstring' option
"
"   Author: Cornelius 林佑安 <cornelius.howl@gmail.com>
"   Date:   四  3/ 4 14:39:34 2010
"   Github: http://github.com/c9s
"   Script Type: plugin
"


fun! s:ensureOnelineBlock(mark,a,e)
  let succ = 1
  for i in range(a:a,a:e)
    if getline(i) !~ '^\s*' . a:mark
      let succ = 0
    endif
  endfor
  return succ
endf

fun! s:getCommentMarks()
  " try to find comment mark pair in &comments.
  let oneline_mark = ''
  let mark1 = ''
  let mark2 = ''

  let cs = split(&comments,',')
  for c in cs 
    " oneline comment
    if c =~ '^s1:'
      let mark1 = strpart(c,3)
    elseif c =~ '^ex:'
      let mark2 = strpart(c,3)
    elseif c =~ '^:'
      let oneline_mark = strpart(c,1) . ' '
    endif
  endfor
  return [ mark1 , mark2 , oneline_mark ]
endf

fun! s:doComment(force_oneline,a,e)
  let cs = &commentstring
  let css = split( cs , '%s' )

  let [mark1,mark2,oneline_mark] = s:getCommentMarks()
  if len(css) == 1 
    if strlen(mark1) > 0 && strlen(mark2) > 0
      let css = [ mark1 , mark2 ]
    endif
  endif
  if strlen(oneline_mark) > 0
    let oneline_mark = oneline_mark . '%s'
  endif

  if a:force_oneline && strlen(oneline_mark) > 0 
    " force single comment mark from 'comments' options
    for i in range(a:a,a:e)
      cal setline(i,printf( oneline_mark , getline(i) ))
    endfor
  elseif len(css) == 2
    " has comment start mark and end mark
    let line = css[0] . getline(a:a)
    cal setline(a:a,line)

    let line = getline(a:e) . css[1]
    cal setline(a:e,line)
  elseif len(css) == 1 
    " single comment mark
    for i in range(a:a,a:e)
      let line = printf(cs,getline(i))
      cal setline(i,line)
    endfor
  endif
endf

fun! s:unComment(a,e)
  let cs = &commentstring
  let css = split( cs , '%s' )

  let [mark1,mark2,oneline_mark] = s:getCommentMarks()
  if len(css) == 1 
    if strlen(mark1) > 0 && strlen(mark2) > 0
      let css = [ mark1 , mark2 ]
    endif
  endif

  if len(css) == 2
    " has comment start mark and end mark
    let css[0] = escape( css[0] , '.*/' )
    let css[1] = escape( css[1] , '.*/' )
    " check if text is mark as begin comment mark and end comment mark
    if strlen(matchstr( getline(a:a),'^'.css[0])) > 0
          \ && strlen(matchstr( getline(a:e),css[1].'\s*$')) > 0

      " unComment
      let line = substitute(getline(a:a),'^'.css[0],'','')
      cal setline(a:a,line)

      let line = substitute(getline(a:e), css[1].'\s*$','','')
      cal setline(a:e,line)
      return 
    endif
  endif


  " pair comment mark not found , try to uncomment oneline mark
  if strlen(oneline_mark) > 0
    let succ = s:ensureOnelineBlock(oneline_mark,a:a,a:e)
    if succ 
      for i in range(a:a,a:e)
        let line = substitute(getline(i),'^\s*'. oneline_mark ,'','')
        cal setline(i,line)
      endfor
      return
    endif
  endif

  " single comment mark
  let succ = s:ensureOnelineBlock(css[0],a:a,a:e)
  if succ
    for i in range(a:a,a:e)
      let line = substitute(getline(i),'^\s*'.css[0],'','')
      cal setline(i,line)
    endfor
    return
  endif
endf


" should also support comment toggle.
fun! s:onelineComment(a,e)
  " force oneline comment
  let [mark1,mark2,oneline_mark] = s:getCommentMarks()
  if strlen(oneline_mark) == 0
    echoerr "Comment String Error"
    return
  endif

  if getline(a:a) =~ '^\s*' . oneline_mark
    cal s:unComment(a:a,a:e)
  else
    cal s:doComment(1,a:a,a:e)
  endif
endf

com! -range DoComment :cal s:doComment(0,<line1>,<line2>)
com! -range UnComment :cal s:unComment(<line1>,<line2>)
com! -range OneLineComment :cal s:onelineComment(<line1>,<line2>)
map <silent>   ,c    :DoComment<CR>
map <silent>   ,C    :UnComment<CR>
map <silent>   ,,    :OneLineComment<CR>
