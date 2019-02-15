import QRCode from 'qrcode'

$(document).ready ->
  index = 1
  mnemonics = wallet.createMnemonic().split(" ")
  mnemonics.map((word) ->
    $('#' + index + 'word').val(word);
    index = index + 1;
  )
  $('.forward-mnemonic').unbind('click').click (event) ->
    event.preventDefault()
    tab = $(this).attr('rel');
    if tab == 'verify' 
      changeHeading('Verify Backup Phrase', 'Please write the correct words')
      removeActiveClassFromTab()
      updateBackButton('#1a', 'setup')
      updateForwordButton('#3a', 'review', 'Verify')
      $('.verify-nav').addClass('active')
      $('#2a').addClass('active')
    else if tab == 'review'
      if verifyMnemonic()
        $('#verify-mnemonic').val('true') 
        changeHeading('Review', 'By using the VodiX Wallet I unserstand that:')
        removeActiveClassFromTab()
        updateBackButton('#2a', 'verify')
        updateForwordButton('#4a', 'confirm', 'Confirm')
        $('.review-nav').addClass('active')
        $('#3a').addClass('active')
        $('.forward-mnemonic').attr("disabled", true);
        $('.forward-mnemonic').removeAttr('href');
      else
        toastr.error('Entered mnemonic does not match with actual mnemonic')
        return
    else if tab == 'setup'
      changeHeading('Setup Account', 'Write down your 12 word backup phrase in correct order')
      removeActiveClassFromTab()
      updateBackButton('/setup_accounts/policy', 'policy')
      updateForwordButton('#2a', 'verify', "I've copied it somewhere safe")
      $('.setup-nav').addClass('active')
      $('#1a').addClass('active')
    else if tab == 'confirm'
      if $('.create-mnemonic-checkbox1').is(':checked') && $('.create-mnemonic-checkbox2').is(':checked')
        mnemonics = walletMnemonics().join(" ")
        keys = wallet.generateKeys(mnemonics);
        $('#wallet-address').val(keys.address)
        $('#private-key').val(keys.privateKey)
        showQrCode(keys.address)
        $('#qr-code').modal('show');
    return

  $('.back-mnemonic').unbind('click').click (event) ->
    event.preventDefault()
    tab = $(this).attr('rel');
    if tab == 'policy'
      window.location.href = '/setup_accounts/policy';
    else
      if tab == 'setup'
        changeHeading('Setup Account', 'Write down your 12 word backup phrase in correct order')
        removeActiveClassFromTab()
        updateBackButton('/setup_accounts/policy', 'policy')
        updateForwordButton('#2a', 'verify', "I've copied it somewhere safe")
        $('#1a').addClass('active')
      else if tab == 'verify'
        changeHeading('Verify Backup Phrase', 'Please write the correct words')
        removeActiveClassFromTab()
        updateBackButton('#1a', 'setup')
        updateForwordButton('#3a', 'review', 'verify')
        $('#2a').addClass('active')
    return

  $('.copy-button').unbind('click').click (event) ->
    words = walletMnemonics()
    tempInput = document.createElement('INPUT')
    $('#1a').append tempInput
    tempInput.setAttribute 'value', words.join(" ")
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

  $('.copy-wallet-button').unbind('click').click (event) ->
    tempInput = document.createElement('INPUT')
    $('#3a').append tempInput
    tempInput.setAttribute 'value', $('#private-key').val()
    tempInput.select()
    document.execCommand('copy')
    tempInput.remove()
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
        toastr.info(result.response.message)
        setTimeout (->
          window.location.href = '/'
          return
        ), 5000
        return
      error: (err) ->
        toastr.error(err.message)
    return

  $('.tab-setup').unbind('click').click (event) ->
    debugger
    changeHeading('Setup Account', 'Write down your 12 word backup phrase in correct order')
    removeActiveClassFromTab()
    updateBackButton('/setup_accounts/policy', 'policy')
    updateForwordButton('#2a', 'verify', "I've copied it somewhere safe")
    $('.setup-nav').addClass('active')
    $('#1a').addClass('active')

  $('.tab-verify').unbind('click').click (event) ->
    changeHeading('Verify Backup Phrase', 'Please write the correct words')
    removeActiveClassFromTab()
    updateBackButton('#1a', 'setup')
    updateForwordButton('#3a', 'review', 'Verify')
    $('.verify-nav').addClass('active')
    $('#2a').addClass('active')

  $('.tab-review').unbind('click').click (event) ->
    if $('#verify-mnemonic').val() == 'false'
      toastr.error('First verify your mnemonics')
      return
    $('.forward-mnemonic').attr("disabled", true);
    $('.forward-mnemonic').removeAttr('href');
    changeHeading('Review', 'By using the VodiX Wallet I unserstand that:')
    removeActiveClassFromTab()
    updateBackButton('#2a', 'verify')
    updateForwordButton('#4a', 'confirm', 'Confirm')
    $('.review-nav').addClass('active')
    $('#3a').addClass('active')

  $('.create-mnemonic-checkbox1').change ->
    if $(this).is(':checked') && $('.create-mnemonic-checkbox2').is(':checked') 
      $('.forward-mnemonic').attr("disabled", false);
      updateForwordButton('#4a', 'confirm', 'Confirm');
    else
      $('.forward-mnemonic').attr("disabled", true);
      $('.forward-mnemonic').removeAttr('href');
    return

  $('.create-mnemonic-checkbox2').change ->
    if $(this).is(':checked') && $('.create-mnemonic-checkbox1').is(':checked') 
      $('.forward-mnemonic').attr("disabled", false);
      updateForwordButton('#4a', 'confirm', 'Confirm');
    else
      $('.forward-mnemonic').attr("disabled", true);
      $('.forward-mnemonic').removeAttr('href');
    return

walletMnemonics = ->
  words = []
  [1,2,3,4,5,6,7,8,9,10,11,12].map((index) ->
    value = $('#' + index + 'word').val()
    words.push(value)
  )
  return words

changeHeading = (heading, subheading) ->
  $('.heading-setup-block').text(heading)
  $('.subheading-setup-block').text(subheading);
  return

removeActiveClassFromTab = ->
  $('#1a').removeClass('active')
  $('#2a').removeClass('active')
  $('#3a').removeClass('active')
  return

updateBackButton = (url, rel) ->
  $('.back-mnemonic').attr('rel', rel)
  if rel == 'policy'
    return
  $('.back-mnemonic').attr('href', 'javascript:void(0)')
  $('.back-mnemonic').attr('tab', url)
  return

updateForwordButton= (url, rel, text) ->
  $('.forward-mnemonic').attr('tab', url)
  $('.forward-mnemonic').attr('rel', rel)
  $('.forward-mnemonic').text(text)

verifyMnemonic = ->
  actualMnemonics = walletMnemonics()
  testMnemonics = ''
  enteredWords = []
  [4,7,9,12].map((index) ->
    value = $('#' + index + 'verify').val()
    testMnemonics = testMnemonics + " " + actualMnemonics[index - 1]
    enteredWords.push(value)
  )
  if testMnemonics.trim() == enteredWords.join(" ")
    return true
  return false

showQrCode = (text) ->
  QRCode.toCanvas document.getElementById('canvas'), text, (error) ->
    if text and error
      console.error error
    console.log 'success!'
    return
  return
