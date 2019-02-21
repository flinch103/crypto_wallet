$(document).ready ->
  $('.cancel-dispute').click (e) ->
    $('#reject-task-field').modal('hide')

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
        toastr.info(result.response.message)
        return
      error: (err) ->
        toastr.error(err.responseText.message)
    return

  $('.vodeer-task-accept, .vodeer-task-submit').click (event) ->
    task_id = $(this).data('id')
    user_id = $(this).data('user')
    status = $(this).data('status')
    if status == "progress"
      data_hash = {task:{vodeer_id: user_id, status: status}}
    else
      data_hash = {task:{status: status}}
    $.ajax
      url: '/tasks/'+ task_id,
      method: 'put',
      data: data_hash,
      success: (result) ->
        return
    return
