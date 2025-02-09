rawSignedTx = require('../lib/generateSignedRawTransactionForSmartContractInteraction')
contractData = require('../lib/getDataFromSmartContract.js')
import { ESCROW_ABI, CONTRACT_ADDRESS, ABI_TOKEN } from '../lib/escrow_constant';
import { WEB3_URl, TOKEN_ABI, TOKEN_CONTRACT, TO_ADDRESS } from '../lib/constant';
Web4 =  require('web3')
arbiterPrivateKey = "0x5fc9b242d9b50ef201a381cc10d31c901193fa5a46d47bb5fbc67a9d06fbddf8";
arbiterWalletAddress = "0x2aea62ba9a46037ee7f3cfd6a11f077795c39bc6";

$(document).ready ->
  validPrivateKey = (walletAddress, privateKey)->
    return wallet.isValidPrivateKey(walletAddress, privateKey)

  $('.cancel-dispute').click (e) ->
    $('#reject-task-field').modal('hide')

  $('.cancel-dispute-arbiter').click (e) ->
    $('#favour-vodiant-task').modal('hide')
    $('#favour-vodeer-task').modal('hide')

  $('.cancel-vodiant-arbiter-button').click (e) ->
    $('#task-dispute-vodiant-arbiter').modal('hide')

  $('.accept-dispute-vodiant-arbiter').click (e) ->
    # $('#task-dispute-vodiant-arbiter').modal({backdrop: 'static',keyboard: false,show: true})
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
        # $('#task-dispute-vodiant-arbiter').modal('hide')
        $('.vodiant-favour').hide()
        $('.vodeer-favour').hide()
        addJob(walletId, arbiterPrivateKey, task_id, "vodiant_favour")
        toastr.info(result.response.message)
        return
      error: (err) ->
        toastr.error(err.responseText.message)
    return
  
  # $('.start-vodiant-arbiter-button').click (e) ->
    # if $('.private-key-accept').val().length == 0
    #   toastr.error('Enter your private key')
    #   return
    # task_id = $('.vodiant-favour').data('id')
    # resolved_id = $('.vodiant-favour').data('user')
    # data_hash = {task:{resolved_id: resolved_id, status: 'resolved'}}

    # $.ajax
    #   url: '/tasks/'+ task_id,
    #   method: 'put',
    #   data: data_hash,
    #   dataType: 'json'
    #   success: (result) ->
    #     $('#favour-vodiant-task').modal('hide');
    #     $('#task-dispute-vodiant-arbiter').modal('hide')
    #     $('.vodiant-favour').hide()
    #     $('.vodeer-favour').hide()
    #     amount = parseInt(2.0) * (10 ** 18)
    #     addJob(walletId, amount, $('.private-key-accept').val(), task_id, "vodiant_favour")
    #     toastr.info(result.response.message)
    #     return
    #   error: (err) ->
    #     toastr.error(err.responseText.message)
    # return

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
        addJob(walletId, arbiterPrivateKey, task_id, "vodeer_favour")
        toastr.info(result.response.message)
        return
      error: (err) ->
        toastr.error(err.responseText.message)
    return

  $('.raise-dispute').click (e) ->
    $('#reject-task-field').modal('hide');
    $('#task-stake-vodeer-dispute').modal({backdrop: 'static',keyboard: false,show: true})

  $('.start-dispute-button').unbind('click').click (event) ->
    privateKey = $('.private-key-accept').val()
    if privateKey.length == 0
      toastr.error('Enter your private key')
      return
    try
      isValidPrivateKey = validPrivateKey(walletAddress, privateKey)
    catch err
      toastr.error('Invalid private key')
      return false
    if !isValidPrivateKey
      toastr.error('Invalid private key')
      return false
    task_id = $(this).data('id')
    user_id = $(this).data('user')
    status = $(this).data('status')
    name = $(this).data('name')
    $.ajax
      url: '/tasks/' + task_id
      method: 'PUT'
      data: { task : { status: 'disputed', dispute_comment: $('.dispute-comment').val() } }
      dataType: 'json'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
        return
      success: (result) ->
        $('#reject-task-field').modal('hide');
        $('#task-stake-vodeer-dispute').modal('hide')
        addJobArbiter(walletId, result.arbiter, privateKey, task_id, "disputed")
        $('.raise-dispute-button').hide()
        $('.vodeer-dispute-status').text('Disputed')
        toastr.info(result.response.message)
        setTimeout (->
          window.location.href = result.response.url
        ), 5000
      error: (err) ->
        toastr.error(err.responseText.message)
    return
  
  $('.cancel-dispute-button').click (e) ->
    $('#task-stake-vodeer-dispute').modal('hide')

  $('.cancel-reject-task').click (e) ->
    $('#reject-field').modal('hide')

  $('.cancel-task-accept-button').click (e) ->
    $('#task-stake-vodiant-accept').modal('hide')

  $('.approve-task').click (e) ->
    $('#task-stake-vodiant-accept').modal({backdrop: 'static',keyboard: false,show: true})

  $('.cancel-task-reject-button').click (event) ->
    $('#task-stake-reject').modal('hide')

  $('.submit-reject-task').click (e) ->
    $('#reject-field').modal('hide');
    $('#task-stake-reject').modal({backdrop: 'static',keyboard: false,show: true})

  $('.start-task-accept-button').unbind('click').click (event) ->
    privateKey = $('.private-key-accept').val()
    if privateKey.length == 0
      toastr.error('Enter your private key')
      return
    try
      isValidPrivateKey = validPrivateKey(walletAddress, privateKey)
    catch err
      toastr.error('Invalid private key')
      return false
    if !isValidPrivateKey
      toastr.error('Invalid private key')
      return false
    task_id = $(this).data('id')
    user_id = $(this).data('user')
    status = $(this).data('status')
    to_status = "rejected"
    name = $(this).data('name')
    $.ajax
      url: '/tasks/' + task_id
      method: 'PUT'
      data: { task : { status: 'approved' } }
      dataType: 'json'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
        return
      success: (result) ->
        $('#task-stake-vodiant-accept').modal('hide')
        addJob(walletId, privateKey, task_id, "accepted")
        $('.complete-buttons').hide()
        $('.status-p').text('Approved')
        toastr.info(result.response.message)
        setTimeout (->
          window.location.href = result.response.url
        ), 5000
      error: (err) ->
        toastr.error(err.responseText.message)


  $('.start-task-reject-button').unbind('click').click (event) ->
    privateKey = $('.private-key').val()
    if privateKey.length == 0
      toastr.error('Enter your private key')
      return
    try
      isValidPrivateKey = validPrivateKey(walletAddress, privateKey)
    catch err
      toastr.error('Invalid private key')
      return false
    if !isValidPrivateKey
      toastr.error('Invalid private key')
      return false
    task_id = $(this).data('id')
    user_id = $(this).data('user')
    status = $(this).data('status')
    to_status = "rejected"
    name = $(this).data('name')
    $.ajax
      url: '/tasks/' + task_id
      method: 'PUT'
      data: { task : { status: 'rejected', rejection_comment: $('.rejected-comment').val() } }
      dataType: 'json'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
        return
      success: (result) ->
        $('#task-stake-reject').modal('hide')
        $('#reject-field').modal('hide');
        addJob(walletId, privateKey, task_id, "rejected")
        $('.complete-buttons').hide()
        $('.status-p').text('Rejected')
        toastr.info(result.response.message)
        setTimeout (->
          window.location.href = result.response.url
        ), 5000
      error: (err) ->
        toastr.error(err.responseText.message)
    return



  $('.start-task-stack-button').unbind('click').click (event) ->
    privateKey = $('.private-key').val()
    if privateKey.length == 0
      toastr.error('Enter your private key')
      return
    try
      isValidPrivateKey = validPrivateKey(walletAddress, privateKey)
    catch err
      toastr.error('Invalid private key')
      return false
    if !isValidPrivateKey
      toastr.error('Invalid private key')
      return false
    task_id = $(this).data('id')
    user_id = $(this).data('user')
    status = $(this).data('status')
    if status == "open"
      to_status = "progress"
      msg = "Task accepted succesfully"
    else if status == "progress"
      to_status = "completed"
      msg = "Task Submitted succesfully"

    name = $(this).data('name')
    data_hash = {task:{vodeer_id: user_id, status: to_status}}
    $.ajax
      url: '/tasks/'+ task_id,
      method: 'put',
      data: data_hash,
      dataType: 'json'
      success: (result) ->
        $('#task-stake-accept').modal('hide')
        addJob(walletId, privateKey, task_id, status)
        toastr.info(msg)
        $('.vodeer-task-accept').hide()
        $('.vodeer-task-submit').hide()
        $('.status-v').text(to_status)
        $('.full-name').text(name) if status == "open"
        setTimeout (->
          window.location.href = result.response.url
        ), 5000
    return

  $('.cancel-task-stake-button').click (event) ->
    $('#task-stake-accept').modal('hide')

  $('.vodeer-task-accept').unbind('click').click (event) ->
    $('#task-stake-accept').modal({backdrop: 'static',keyboard: false,show: true})
    
  $('.vodeer-task-submit').unbind('click').click (event) ->
    isFiveMinPast = ((new Date) - updated_at) > FIVE_MINUTES
    if (isFiveMinPast)
      $('#task-stake-accept').modal({backdrop: 'static',keyboard: false,show: true})
    else
      toastr.error('You need to work for atleast 5 min on the task before submitting')
      return false
    # $('.start-task-stack-button').text('Stake Token and Submit Task')

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


addJob = (walletId, privateKey, task_id, status) ->
  if status == "open"
    txData = await rawSignedTx.default(CONTRACT_ADDRESS, 'applyForJob', [task_id], ESCROW_ABI, privateKey, false)
  else if status == "progress"
    txData = await rawSignedTx.default(CONTRACT_ADDRESS, 'submitWork', [task_id], ESCROW_ABI, privateKey, false)
  else if status == "rejected"
    txData = await rawSignedTx.default(CONTRACT_ADDRESS, 'dissatisfactoryWorkSubmitted', [task_id], ESCROW_ABI, privateKey, false)
  else if status == "accepted"
    txData = await rawSignedTx.default(CONTRACT_ADDRESS, 'approveWork', [task_id], ESCROW_ABI, privateKey, false)
  else if status == "vodiant_favour"
    txData = await rawSignedTx.default(CONTRACT_ADDRESS, 'negativeVerdict', [task_id], ESCROW_ABI, privateKey, false)
  else if status == "vodeer_favour"
    txData = await rawSignedTx.default(CONTRACT_ADDRESS, 'positiveVerdict', [task_id], ESCROW_ABI, privateKey, false)

  web4 = new Web4(new Web4.providers.HttpProvider(WEB3_URl));
  web4.eth.sendRawTransaction txData, (err, hash) ->
    if !err
      if status == "open"
        addTransaction(walletId, hash, 'apply_job', task_id)
      else if status == "progress"
        addTransaction(walletId, hash, 'job_submit', task_id)
      else if status == "rejected"
        addTransaction(walletId, hash, 'job_reject', task_id)
      else if status == "accepted"
        addTransaction(walletId, hash, 'job_accept', task_id)
      else if status == "vodiant_favour"
        addTransaction(walletId, hash, 'job_vodiant_favor', task_id)
      else if status == "vodeer_favour"
        addTransaction(walletId, hash, 'job_vodeer_favor', task_id)
      # $('#create-field').modal('show')
    else
      console.log err
    return

addJobArbiter = (walletId, arbiterAddress, privateKey, task_id, status) ->
  txData = await rawSignedTx.default(CONTRACT_ADDRESS, 'raiseDispute', [task_id, arbiterAddress], ESCROW_ABI, privateKey, false)
  web4 = new Web4(new Web4.providers.HttpProvider(WEB3_URl));
  web4.eth.sendRawTransaction txData, (err, hash) ->
    if !err
        addTransaction(walletId, hash, 'job_dispute', task_id)
      # $('#create-field').modal('show')
    else
      console.log err
    return

addTransaction = (walletId, hash, type, task_id) ->
  url = '/wallets/' + walletId + '/transactions'
  $.ajax
    url: url
    method: 'POST'
    data: { tx_hex: hash, status: 'pending', sent: true, tx_type: type, task_id: task_id }
    beforeSend: (xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
      return
    success: (result) ->      
      return
    error: (err) ->
      # toastr.error(err.message)

toHex = (str) ->
  hex = '';
  i = 0
  while i < str.length
    hex += '' + str.charCodeAt(i).toString(16)
    i++
  return hex
