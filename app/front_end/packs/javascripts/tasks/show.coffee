$(document).ready ->
  $('.cancel-dispute').click (e) ->
    $('#reject-task-field').modal('hide')

  $('.cancel-dispute-arbiter').click (e) ->
    $('#favour-vodiant-task').modal('hide')
    $('#favour-vodeer-task').modal('hide')

  $('.accept-dispute-vodiant-arbiter').click (e) ->
    task_id = $('.vodiant-favour').data('id')
    resolved_id = $('.vodiant-favour').data('user')
    data_hash = {task:{resolved_id: resolved_id, status: 'resolved'}}
    $.ajax
      url: '/tasks/'+ task_id,
      method: 'put',
      data: data_hash,
      dataType: 'json'
      success: (result) ->
        $('#favour-vodiant-task').modal('hide');
        $('.vodiant-favour').hide()
        $('.vodeer-favour').hide()
        toastr.info(result.response.message)
        return
      error: (err) ->
        toastr.error(err.responseText.message)
    return

  $('.accept-dispute-vodeer-arbiter').click (e) ->
    task_id = $('.vodeer-favour').data('id')
    resolved_id = $('.vodeer-favour').data('user')
    data_hash = {task:{resolved_id: resolved_id, status: 'resolved'}}
    $.ajax
      url: '/tasks/'+ task_id,
      method: 'put',
      data: data_hash,
      dataType: 'json'
      success: (result) ->
        $('#favour-vodeer-task').modal('hide');
        $('.vodiant-favour').hide()
        $('.vodeer-favour').hide()
        toastr.info(result.response.message)
        return
      error: (err) ->
        toastr.error(err.responseText.message)
    return

  $('.raise-dispute').click (e) ->
    $.ajax
      url: '/tasks/' + $('.dispute-comment').attr('task_id')
      method: 'PUT'
      data: { task : { status: 'disputed', dispute_comment: $('.dispute-comment').val() } }
      dataType: 'json'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
        return
      success: (result) ->
        $('#reject-task-field').modal('hide');
        $('.raise-dispute-button').hide()
        $('.vodeer-dispute-status').text('Disputed')
        toastr.info(result.response.message)
        return
      error: (err) ->
        toastr.error(err.responseText.message)
    return

  $('.cancel-reject-task').click (e) ->
    $('#reject-field').modal('hide')

  $('.approve-task').click (e) ->
    $.ajax
      url: '/tasks/' + $('.approve-task').attr('task_id')
      method: 'PUT'
      data: { task : { status: 'approved' } }
      dataType: 'json'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
        return
      success: (result) ->
        toastr.info(result.response.message)
        $('.complete-buttons').hide()
        $('.status-p').text('Approved')
        return
      error: (err) ->
        toastr.error(err.responseText.message)

  $('.submit-reject-task').click (e) ->
    $.ajax
      url: '/tasks/' + $('.approve-task').attr('task_id')
      method: 'PUT'
      data: { task : { status: 'rejected', rejection_comment: $('.rejected-comment').val() } }
      dataType: 'json'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
        return
      success: (result) ->
        $('#reject-field').modal('hide');
        $('.complete-buttons').hide()
        $('.status-p').text('Rejected')
        toastr.info(result.response.message)
        return
      error: (err) ->
        toastr.error(err.responseText.message)
    return

  $('.vodeer-task-accept').click (event) ->
    task_id = $(this).data('id')
    user_id = $(this).data('user')
    status = $(this).data('status')
    name = $(this).data('name')
    msg = "Task accepted succesfully"
    data_hash = {task:{vodeer_id: user_id, status: status}}
    $.ajax
      url: '/tasks/'+ task_id,
      method: 'put',
      data: data_hash,
      dataType: 'json'
      success: (result) ->
        toastr.info(msg)
        $('.vodeer-task-accept').hide()
        $('.status-v').text('Progress')
        $('.full-name').text(name)
        return
    return

  $('.vodeer-task-submit').click (event) ->
    task_id = $(this).data('id')
    user_id = $(this).data('user')
    status = $(this).data('status')
    msg = "Task submitted succesfully"
    data_hash = {task:{status: status}}
    $.ajax
      url: '/tasks/'+ task_id,
      method: 'put',
      data: data_hash,
      dataType: 'json'
      success: (result) ->
        toastr.info(msg)
        $('.vodeer-task-submit').hide()
        $('.status-v').text('Completed')
        return
    return


  $(".task-progress-dash").on "click", ->
    window.location.href = "/tasks?filter_type=ongoing"

  $(".task-open-dash").on "click", ->
    window.location.href = "/tasks?filter_type=open"

  $(".task-completed-dash").on "click", ->
    window.location.href = "/tasks?filter_type=completed"

  $(".task-disputed-dash").on "click", ->
    window.location.href = "/tasks?filter_type=disputed"

  $(".task-progressv-dash").on "click", ->
    window.location.href = "/tasks?filter_type=ongoing"

  $(".task-approvedv-dash").on "click", ->
    window.location.href = "/tasks?filter_type=approved"

  $(".task-completedv-dash").on "click", ->
    window.location.href = "/tasks?filter_type=completed"

  $(".task-disputedv-dash").on "click", ->
    window.location.href = "/tasks?filter_type=disputed"

  $(".task-assigned-arbiter").on "click", ->
    window.location.href = "/tasks?filter_type=assigned"

  $(".task-resolved-arbiter").on "click", ->
    window.location.href = "/tasks?filter_type=resolved"

  $(".wallet").on "click", ->
    window.location.href = "/wallets/"