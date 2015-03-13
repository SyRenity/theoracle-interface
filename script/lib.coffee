HDKey = require 'hdkey'
{ sha256, sha256ripe160 } = require 'crypto-hashing'
{ createMultiSigOutputScript } = require 'btc-script'
coinstring = require 'coinstring'
coininfo = require 'coininfo'

oracle_master = new Buffer process.env.MASTER_PUB, 'hex'
currency = process.env.CURRENCY
{ versions } = coininfo currency

make_multisig = (contract_script, alice_pub, bob_pub) ->
	oracle_pub = derive_pub oracle_master, sha256 contract_script

	pubkeys_ba = [ oracle_pub, alice_pub, bob_pub ].map (x) -> Array.apply null, x
	multisig_script = createMultiSigOutputScript(2, pubkeys_ba, true)
	scripthash = sha256ripe160 multisig_script.buffer
	multisig_addr = coinstring.encode scripthash, versions.scripthash

	{ oracle_pub, multisig_script, multisig_addr }

derive_pub = (parent, chain_code) ->
	hd = new HDKey
	hd.chainCode = chain_code
	hd.publicKey = parent
	hd.deriveChild(0).publicKey

module.exports = { make_multisig }
