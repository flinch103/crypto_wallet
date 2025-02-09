import { WEB3_URl, TOKEN_ABI, TOKEN_CONTRACT, TO_ADDRESS } from '../lib/constant';
Web4 =  require('web3')
Tx = require('ethereumjs-tx');

# Refresh balance
$(document).on 'click', '#refresh_balance', ->
  $(".balance-loader").show();
  $("#refresh_balance").hide()
  confirmPrivateKey();

$(document).ready ->
  $('.platform-stack-confirm').click (event) ->
    confirmPrivateKey();

transfer = (privateKey, from, walletId) ->
  to = TO_ADDRESS
  from = from
  web4 = new Web4(new Web4.providers.HttpProvider(WEB3_URl));
  Contract = web4.eth.contract(TOKEN_ABI)
  contractInstance = Contract.at(TOKEN_CONTRACT)
  decimals = contractInstance.decimals()
  value = 20 * (10 ** decimals)
  data = contractInstance.transfer.getData(to, value, {from: from})
  console.log(data)
  gasPrice = web4.toHex(web4.eth.gasPrice)
  count = web4.eth.getTransactionCount(from)
  nonce = web4.toHex(count)
  gasLimit = web4.eth.estimateGas({ data, from, to })
  console.log(gasLimit);
  rawTransaction = {
    "from": from,
    "nonce": nonce,
    "gasPrice": gasPrice,
    "gasLimit": 4 * gasLimit,
    "to": TOKEN_CONTRACT,
    "value": '0x0',
    "data": data
  };

  privKey =  Buffer.from(privateKey.slice(2), 'hex')
  tx = new Tx(rawTransaction)
  tx.sign(privKey)
  serializedTx = tx.serialize()
  web4.eth.sendRawTransaction '0x' + serializedTx.toString('hex'), (err, hash) ->
    if !err
      url = '/wallets/' + walletId + '/transactions'
      $.ajax
        url: url
        method: 'POST'
        data: { tx_hex: hash, status: 'pending', sent: true, amount: 20, tx_type: 'platform_stack' }
        beforeSend: (xhr) ->
          xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
          return
        success: (result) ->
          toastr.info(result.response.message + '. You will be redirected to your dashboard')
          setTimeout (->
            window.location.href = '/'
            return
          ), 5000
          return
        error: (err) ->
          toastr.error(err.message)
    else
      toastr.error('Transfer required VDX token!')
    return


confirmPrivateKey = ->
  key =  $('.private-key').val()
  walletAddress = $('.wallet-address').val()
  walletId = $('.wallet-address').attr('wallet_id')
  if key.length == 0
    toastr.error('Please enter your private key')
    return
  isValidPrivateKey = wallet.isValidPrivateKey(walletAddress, key)
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
      if(balance.toFixed(2) < 20)
        $("#wallet_balance_container").addClass('error').html("Your wallet balance is low <img src='/assets/loading.png' class='balance-loader'/> <a id= 'refresh_balance' class='cursor-pointer'>Refresh</a>")
      else
        $("#wallet_balance_container").html("")
        transfer(key, walletAddress, walletId)
      return
    return
