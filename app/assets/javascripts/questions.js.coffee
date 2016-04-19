$('#ajax').html '<%= escape_javascript(render(:partial => \'layouts/breadcrumb\')).html_safe %>'

$ ->
$.ajax
vote_up = ->
xhttp = new XMLHttpRequest

xhttp.onreadystatechange = ->
  if xhttp.readyState == 4 and xhttp.status == 200
    document.getElementById('up_vote').innerHTML = xhttp.responseText
  return

xhttp.open 'POST', '/questions', true
xhttp.send()
return