import { WEB3_URl, TOKEN_ABI, TOKEN_CONTRACT, TO_ADDRESS } from '../lib/constant';
Web4 =  require('web3')

$(document).ready ->
  if (isUserArbiter == "false")
    tokenBalance()
    if $('.platform-stack-tx').attr('status') == 'success'
      return
    else
      return
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
    else if resp.status == 'failed'
      $('#transaction_status').html("Your platform stack transaction failed. <a href='/setup_accounts/platform_stack'>Please try again.</a>")
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

tokenBalance = ->
  web4 = new Web4(new Web4.providers.HttpProvider(WEB3_URl));
  Contract = web4.eth.contract(TOKEN_ABI)
  contractInstance = Contract.at(TOKEN_CONTRACT)
  decimal = contractInstance.decimals()
  contractInstance.balanceOf walletAddress, (error, balance) ->
    contractInstance.decimals (error, decimals) ->
      balance = balance.div(10 ** decimals)
      $('.wallet-vdx-bal').text(balance.toFixed(2))
      return
    return
