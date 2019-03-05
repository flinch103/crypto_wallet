rawSignedTx = require('../lib/generateSignedRawTransactionForSmartContractInteraction')
contractData = require('../lib/getDataFromSmartContract.js')
import { ESCROW_ABI, CONTRACT_ADDRESS, ABI_TOKEN } from '../lib/escrow_constant';
import { WEB3_URl, TOKEN_ABI, TOKEN_CONTRACT, TO_ADDRESS } from '../lib/constant';
Web4 =  require('web3')

$(document).ready ->
  $('#datepicker').datepicker(
    startDate: '-0m'
    autoclose: true
    todayHighlight: true).datepicker 'update', new Date

  validPrivateKey = (walletAddress, privateKey)->
    return wallet.isValidPrivateKey(walletAddress, privateKey)

  $('.task-payment-buttons').hide()
  
  $('.task-payment-tab').click (event) ->
    check = checkInputFields()
    integer_check = checkCostField()
    if !check
      toastr.error('Please fill complete form')
      $('#task-tab').addClass('active')
      $('#payment-tab').removeClass('active')
    else if !integer_check
      toastr.error(numericalErrMsg())
      $('#task-tab').addClass('active')
      $('#payment-tab').removeClass('active')
    else if $('#task_wage').val().length > 6
      toastr.error('Cost should be less than equal to 6 digits')
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
    integer_check = checkCostField()
    if !check
      toastr.error('Please fill complete form')
    else if !integer_check
      toastr.error(numericalErrMsg())
    else if $('#task_wage').val().length > 6
      toastr.error('Cost should be less than equal to 6 digits')
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
    privateKey =  $('.private-key').val()
    if privateKey.length == 0
      toastr.error('Please enter your private key')
      return
    isValidPrivateKey = wallet.isValidPrivateKey(walletAddress, privateKey)
    if !isValidPrivateKey
      toastr.error('Invalid private key')
      return false
    web4 = new Web4(new Web4.providers.HttpProvider(WEB3_URl));
    Contract = web4.eth.contract(TOKEN_ABI)
    contractInstance = Contract.at(TOKEN_CONTRACT)
    decimal = contractInstance.decimals()
    contractInstance.balanceOf walletAddress, (error, balance) ->
      contractInstance.decimals (error, decimals) ->
        balance = balance.div(10 ** decimals)
        if(balance.toFixed(2) < parseFloat($("#task_wage").val()))
          toastr.error("You don't have sufficient balance")
        else
          return false
          submitTask(privateKey)
        return
      return
  submitTask = (privateKey) ->
    data = $('#task-form').serialize()
    $.ajax
      url: '/tasks'
      method: 'POST'
      data: data
      dataType: 'json'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
        return
      success: (result) ->
        $('.task-payment-buttons').hide()
        id  = result.id
        amount = parseFloat($('#task_wage').val()) * (10 ** 18)
        approve($('#task-wallet').val(), amount, privateKey, id)
        $('#create-field').modal({backdrop: 'static',keyboard: false,show: true})
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

checkCostField = ->
  flag = true
  formData = JSON.parse(JSON.stringify($('#task-form').serializeArray())).slice(2)
  formData = formData[1]
  reg = /^[+]?([1-9][0-9]*(?:[\.][0-9]*)?|0*\.0*[1-9][0-9]*)(?:[eE][+-][0-9]+)?$/
  unless reg.test(formData.value)
    flag = false
  
  return flag

addJob = (walletId, amount, privateKey, task_id) ->
  description = '0x' + toHex('Test Job')
  txData = await rawSignedTx.default(CONTRACT_ADDRESS, 'addJob', [task_id, amount], ESCROW_ABI, privateKey, true)
  web4 = new Web4(new Web4.providers.HttpProvider(WEB3_URl));
  web4.eth.sendRawTransaction txData, (err, hash) ->
    if !err
      addTransaction(walletId, hash, amount, 'add_job', task_id)
      $('#create-field').modal('show')
    else
      console.log err
    return


approve = (walletId, amount, privateKey, task_id) ->
  txData = await rawSignedTx.default(TOKEN_CONTRACT, 'approve', [CONTRACT_ADDRESS, amount], ABI_TOKEN, privateKey, false)
  addJob(walletId, amount, privateKey, task_id)
  web4 = new Web4(new Web4.providers.HttpProvider(WEB3_URl));
  web4.eth.sendRawTransaction txData, (err, hash) ->
    if !err
      addTransaction(walletId, hash, amount, 'approve', task_id)
    else
      console.log err
    return

addTransaction = (walletId, hash, amount, type, task_id) ->
  amount = parseFloat($('#task_wage').val())
  url = '/wallets/' + walletId + '/transactions'
  $.ajax
    url: url
    method: 'POST'
    data: { tx_hex: hash, status: 'pending', sent: true, amount: amount, tx_type: type, task_id: task_id }
    beforeSend: (xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
      return
    success: (result) ->      
      return
    error: (err) ->
      toastr.error(err.message)

toHex = (str) ->
  hex = '';
  i = 0
  while i < str.length
    hex += '' + str.charCodeAt(i).toString(16)
    i++
  return hex

numericalErrMsg = ->
  if parseFloat($('#task_wage').val()) < 1
    return 'Cost should be greater than equal to 1'
  else
    return 'Cost should be numerical'
