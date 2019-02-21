import { WEB3_URl, TOKEN_ABI, TOKEN_CONTRACT, TO_ADDRESS } from '../lib/constant';
Web4 =  require('web3')
Tx = require('ethereumjs-tx');

$(document).ready ->
  $('.task-payment').click (event) ->
    address = $('.wallet-address').val()
    key =  $('.private-key').val()
    walletId = $('.wallet-address').attr('wallet_id')
    transfer(key, address, walletId)

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
      receipt = await web4.eth.getTransactionReceipt('0xee68486423e3e50b1f5023e3a1f6e1d31d25098592f9d7779a85b6d75154736e')
      if receipt != null
        url = '/wallets/' + walletId + '/transactions'
        $.ajax
          url: '/tasks'
          method: 'POST'
          data: { tx_hex: hash, status: 'success', sent: true, amount: 20, tx_type: 'task_stack' }
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
      console.log err
    return