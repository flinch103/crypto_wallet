$(document).ready ->
  $('#datepicker').datepicker(
    autoclose: true
    todayHighlight: true).datepicker 'update', new Date

  $('.task-payment-buttons').hide()
  
  $('.task-payment-tab').click (event) ->
    check = checkInputFields()
    if !check
      toastr.error('Please fill complete form')
      $('#task-tab').addClass('active')
      $('#payment-tab').removeClass('active')
    else
      $('#task-tab').removeClass('active')
      $('#payment-tab').addClass('active')
      $('#payvdx').addClass('active')
      $('#task-detail').removeClass('active')
      $('.task-payment-buttons').show()
      $('.task-tab-next').hide()
      $('.payment-wage').text($('#task_wage').val())

  $('.task-form-tab').click (event) ->
    $('.task-payment-buttons').hide()
    $('.task-tab-next').show()

  $('.next-button').click (event) ->
    check = checkInputFields()
    if !check
      toastr.error('Please fill complete form')
    else
      $('#payvdx').addClass('active')
      $('#task-detail').removeClass('active')
      $('.task-payment-buttons').show()
      $('.task-tab-next').hide()
      $('.payment-wage').text($('#task_wage').val())
      $('.task-payment-tab').parent().addClass('active')
      $('.task-form-tab').parent().removeClass('active')

  $('.back-button').click (event) ->
    $('.task-payment-buttons').hide()
    $('.task-tab-next').show()
    $('.task-payment-tab').parent().removeClass('active')
    $('.task-form-tab').parent().addClass('active')

  $('.task-stack-button').click (event) ->
    $.ajax
      url: '/tasks'
      method: 'POST'
      data: $('#task-form').serialize()
      dataType: 'json'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
        return
      success: (result) ->
        $('.task-payment-buttons').hide()
        $('#create-field').modal('show')
        return
      error: (err) ->
        toastr.error($.parseJSON(err.responseText).message)
    return

checkInputFields = ->
  flag = true
  formData = JSON.parse(JSON.stringify($('#task-form').serializeArray())).slice(2)
  formData.map((elm) ->
    if elm.value == ''
      flag = false
  )

  return flag
