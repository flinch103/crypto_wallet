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
  return
