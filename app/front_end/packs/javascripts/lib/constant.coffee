module.exports = {
  WEB3_URl: 'https://ropsten.infura.io/v3/46fa54bae06446e592498ca188cbece5',
  TOKEN_ABI: [
    {
      'constant': true
      'inputs': [ {
        'name': '_owner'
        'type': 'address'
      } ]
      'name': 'balanceOf'
      'outputs': [ {
        'name': 'balance'
        'type': 'uint256'
      } ]
      'type': 'function'
    }
    {
      'constant': true
      'inputs': []
      'name': 'decimals'
      'outputs': [ {
        'name': ''
        'type': 'uint8'
      } ]
      'type': 'function'
    }
    {
      'constant': false
      'inputs': [
        {
          'name': '_to'
          'type': 'address'
        }
        {
          'name': '_value'
          'type': 'uint256'
        }
      ]
      'name': 'transfer'
      'outputs': [ {
        'name': ''
        'type': 'bool'
      } ]
      'type': 'function'
  }
]
  TOKEN_CONTRACT: '0x04e965e94fd2856c1686fe53bff4b964c68a9dc4'
  TO_ADDRESS: '0x96E3F15894944FFd32DeFc2016da209dD4f8d69b'
}
