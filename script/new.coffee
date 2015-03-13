{ createMultiSigOutputScript } = require 'btc-transaction'
{ sha256, sha256ripe160 } = require 'crypto-hashing'
coinstring = require 'coinstring'
qruri = require 'qruri'
oracle_master = new Buffer '', 'hex'

base_url = process.env.URL

$('form').submit (e) ->
  e.preventDefault()

  $t = $ this
  script = $t.find('[name=contract-script]').val()
  alice_pub = new Buffer $t.find('[name=alice]').val(), 'hex'
  bob_pub = new Buffer $t.find('[name=bob]').val(), 'hex'

  chaincode = sha25 contract_script
  oracle_pub = derive_pub oracle_master, chaincode

  pubkeys_ba = [ oracle_pub, alice_pub, bob_pub ].map (x) -> Array.apply null, x
  multisig_script = createMultiSigOutputScript(2, pubkeys_ba, true)
  scripthash = sha256ripe160 multisig_script.buffer
  multisig_addr = coinstring.encode scripthash, versions.scripthash
  multisig_qr = qruri 'bitcoin:' + multisig_addr

  execution_params = a: alice_pub.toString('base64'), b: bob_pub.toString('base64'), s: script
  url = base_url + '/release?' + qr.stringify execution_params

  $ dialog_tmpl { multisig_addr, multisig_qr, url }
    .modal()

derive_pub = (parent, chain_code) ->
  hd = new HDKey
  hd.chainCode = chain_code
  hd.publicKey = parent
  hd.deriveChild(0).publicKey
