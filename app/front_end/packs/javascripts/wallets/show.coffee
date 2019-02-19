import QRCode from 'qrcode'
import { WEB3_URl, TOKEN_ABI, TOKEN_CONTRACT } from '../lib/constant';
Web4 =  require('web3')

QRCode.toCanvas document.getElementById('canvas'), wallet_address, (error) ->
  if wallet_address and error
    console.error error
  console.log 'success!'
  return

$(document).ready ->
  ethBalance()
  tokenBalance()
  $('.wallet-address-copy').click (event) ->
    tempInput = document.createElement('INPUT')
    $('.copy-field').append tempInput
    tempInput.setAttribute 'value', $('.wallet-address').text()
    tempInput.select()
    document.execCommand('copy')
    tempInput.remove()
    return

ethBalance = ->
  walletAddress = $('.wallet-address').text().trim()
  web4 = new Web4(new Web4.providers.HttpProvider(WEB3_URl));
  balance = web4.eth.getBalance(walletAddress);
  $('.eth-balance').text(balance)

tokenBalance = ->
  walletAddress = $('.wallet-address').text().trim()
  web4 = new Web4(new Web4.providers.HttpProvider(WEB3_URl));
  Contract = web4.eth.contract(TOKEN_ABI)
  contractInstance = Contract.at(TOKEN_CONTRACT)
  decimal = contractInstance.decimals()
  console.log(decimal);
  contractInstance.balanceOf walletAddress, (error, balance) ->
    contractInstance.decimals (error, decimals) ->
      balance = balance.div(10 ** decimals)
      $('.vodix-balance').text(balance)
      return
    return
