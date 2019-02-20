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