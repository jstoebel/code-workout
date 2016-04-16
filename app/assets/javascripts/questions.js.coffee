$(document).ready ->
  $('input[type=submit]').on 'click', (event) ->
    form = $(this).parent('form')
    even.preventDefault()
    $.ajax
      type: 'POST'
      url: form.attr('action')
      data: form.serialize()
      success: (data) ->
      error: (data) ->
      dataType: 'JSON'
    return
  return