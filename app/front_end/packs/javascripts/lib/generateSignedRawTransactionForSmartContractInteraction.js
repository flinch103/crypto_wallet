import EthereumTx from 'ethereumjs-tx'
import EthereumWallet from 'ethereumjs-wallet'
import web3 from './web3'


const getEstimatedGas = async (data, from, to) => {
  const gas = web3.eth.estimateGas({ data, from, to })
  return gas
}

const getGasPriceFromBlockChain = async () => {
  return web3.toHex(web3.eth.gasPrice)
}

const getNonceFromBlockChain = async (fromAddress, addJobFlag) => {
  var count = web3.eth.getTransactionCount(fromAddress)
  if(addJobFlag){
    count = count + 1;
  }
  return web3.toHex(count)
}

const generateRawTransaction = async (fromAddress, toAddress, value, data, addJobFlag) => {
  const nonce = await getNonceFromBlockChain(fromAddress, addJobFlag)
  var gasPrice = await getGasPriceFromBlockChain()
  var gasLimit
  if(addJobFlag){
    gasPrice = 0.95 * gasPrice;
    gasLimit = 200000;
  }
  else{
    gasLimit = await getEstimatedGas(data, fromAddress, toAddress)
  }
  return {
    from: fromAddress,
    nonce,
    gasPrice,
    gasLimit,
    to: toAddress,
    value,
    data
  }
}

const generateSignedTransaction = async (rawTx, privateKey) => {
  const userWallet = EthereumWallet.fromPrivateKey(
    Buffer.from(privateKey.replace(/^(0x)/, ''), 'hex')
  )
  const tx = new EthereumTx(rawTx)
  tx.sign(userWallet.getPrivateKey())
  return `0x${tx.serialize().toString('hex')}`
}

const generateDataForSmartContractInteraction = async (
  contractAddress,
  contractFunctionName,
  contractArguments,
  abi
) => {
  let Contract, contractInstance
  Contract = web3.eth.contract(abi)
  contractInstance = Contract.at(contractAddress)
  contractArguments = contractArguments || []
  return contractInstance[contractFunctionName].getData(...contractArguments)
}

const generateSignedRawTransactionForSmartContractInteraction = async (
  contractAddress,
  contractFunctionName,
  contractArguments,
  abi,
  privateKey,
  addJobFlag
) => {
  const userWallet = EthereumWallet.fromPrivateKey(
    Buffer.from(privateKey.replace(/^(0x)/, ''), 'hex')
  )

  const contractData = await generateDataForSmartContractInteraction(
    contractAddress,
    contractFunctionName,
    contractArguments,
    abi
  )
  const rawTx = await generateRawTransaction(
    userWallet.getAddressString(),
    contractAddress,
    0,
    contractData,
    addJobFlag
  )

  const signedTransaction = await generateSignedTransaction(
    rawTx,
    userWallet.getPrivateKey().toString('hex')
  )

  return signedTransaction
}

export default generateSignedRawTransactionForSmartContractInteraction
