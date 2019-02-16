import QRCode from 'qrcode'
$(document).ready ->
  $('.policy-continue').attr("disabled", true);
  $('.policy-continue').removeAttr('href');
  
  $('.mnemonic-backup-checkbox').change ->
    if $(this).is(':checked')
      $('.policy-continue').attr("disabled", false);
      $('.policy-continue').attr('href', '/setup_accounts/create_mnemonic');
    else
      $('.policy-continue').attr("disabled", true);
      $('.policy-continue').removeAttr('href');
    return

  $('.import-tab').unbind('click').click (event) ->
    $('.access-block').hide();
    return

  $('.create-tab').unbind('click').click (event) ->
    $('.access-block').show();
    return

  $('.import-submit').unbind('click').click (event) ->
    mnemonics = walletMnemonics().join(" ")
    if wallet.validateMnemonic(mnemonics)
      keys = wallet.generateKeys(mnemonics);
      $('#wallet-address').val(keys.address)
      $('#private-key').val(keys.privateKey)
      showQrCode(keys.address)
      $('#qr-code').modal('show');
    else
      toastr.error('Invalid Mnemonic!')

  $('.copy-wallet-button').unbind('click').click (event) ->
    tempInput = document.createElement('INPUT')
    $('#import').append tempInput
    tempInput.setAttribute 'value', $('#private-key').val()
    tempInput.select()
    document.execCommand('copy')
    tempInput.remove()
    return

  $('.download-button').unbind('click').click ->
    data = { walletAddress: $('#wallet-address').val(), privateKey: $('#private-key').val()}
    $('<a />',
      'download': 'wallet.json'
      'href': 'data:application/json,' + encodeURIComponent(JSON.stringify(data))).appendTo('body').click(->
      $(this).remove()
      return
    )[0].click()
    return

  $('.create-wallet').unbind('click').click (event) ->
    $.ajax
      url: '/wallets'
      method: 'POST'
      data: address: $('#wallet-address').val()
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
        return
      success: (result) ->
        $('#qr-code').modal('hide');
        toastr.info(result.response.message + '. You will be redirected to your dashboard')
        setTimeout (->
          window.location.href = '/'
          return
        ), 5000
        return
      error: (err) ->
        toastr.error(err.message)
    return


walletMnemonics = ->
  words = []
  [1,2,3,4,5,6,7,8,9,10,11,12].map((index) ->
    value = $('#' + index + 'word').val()
    words.push(value)
  )
  return words

showQrCode = (text) ->
  QRCode.toCanvas document.getElementById('canvas'), text, (error) ->
    if text and error
      console.error error
    console.log 'success!'
    return
  return
