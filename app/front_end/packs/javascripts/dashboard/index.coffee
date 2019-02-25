import { WEB3_URl, TOKEN_ABI, TOKEN_CONTRACT, TO_ADDRESS } from '../lib/constant';
Web4 =  require('web3')

$(document).ready ->
  if $('.platform-stack-tx').attr('status') == 'success'
    return
  else
    $('#dashboard-disable').modal({
      backdrop: 'static',
      keyboard: false
    })
    checkForTxStatus()

checkForTxStatus = () ->
  web4 = new Web4(new Web4.providers.HttpProvider(WEB3_URl));
  interval = setInterval((->
    resp = await getTxStatus($('.platform-stack-tx').attr('id'))
    if resp.status == 'success'
      $('#dashboard-disable').modal('hide')
      clearInterval interval
  ), 2000)

getTxStatus = (id) ->
  status
  $.ajax
    url: '/transactions/' + id + '/status'
    method: 'get'
    beforeSend: (xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
      return
    success: (result) ->
      status = result.status
      return status
    error: (err) ->
      toastr.error(err.message)