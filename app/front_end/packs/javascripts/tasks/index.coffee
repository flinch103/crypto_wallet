$(document).ready ->
  $('.task_filters').click (event) ->
    $(".task_filters").removeClass('active')
    $(this).addClass('active')
    filter_type = $(this).data('tab')
    $.ajax
      url: '/tasks/',
      method: 'get',
      data: {filter_type: filter_type},
      success: (result) ->
        $("#task-open").html(result)
        return
    return
