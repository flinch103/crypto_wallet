$('#vodiant').click (event) ->
  $('#vodeer').removeClass('active')
  $('#arbiter').removeClass('active')
  $(this).addClass('active')
  $('.user-role').val('vodiant')
  return

$('#vodeer').click (event) ->
  $('#vodiant').removeClass('active')
  $('#arbiter').removeClass('active')
  $(this).addClass('active')
  $('.user-role').val('vodeer')
  return

$('#arbiter').click (event) ->
  $('#vodiant').removeClass('active')
  $('#vodeer').removeClass('active')
  $(this).addClass('active')
  $('.user-role').val('arbiter')
  return