readURL = (input) ->
  if input.files and input.files[0]
    reader = new FileReader
    reader.onload = (e) ->
      $('#imagePreview').css 'background-image', 'url(' + e.target.result + ')'
      $('#imagePreview').hide()
      $('#imagePreview').fadeIn 650
      return

    reader.readAsDataURL input.files[0]
  return

$('#imageUpload').change -> 
  readURL this
  profileData = new FormData()
  profileData.append('avatar', this.files[0])
  $.ajax
      url: '/profile/upload_image'
      type: 'POST'
      processData: false
      contentType: false
      cache: false
      data: profileData
      success: (result) ->
        return 
      error: (err) ->
        toastr.error(err.responseText.message)
    return
  return

$('#user-name').change -> 
  val = $("#user-name").val()
  if val.length !=0
    $.ajax
        url: '/profile/update_name'
        type: 'POST'
        data: { profile : { full_name: val } }
        dataType: 'json'
        success: (result) ->
          return 
        error: (err) ->
          toastr.error(err.responseText.message)
      return
    return
