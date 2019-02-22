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
    receipt = await web4.eth.getTransactionReceipt($('.platform-stack-tx').attr('hash'))
    if receipt != null
      $('#dashboard-disable').modal('hide')
      clearInterval interval
    return
  ), 2000)
