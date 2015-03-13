qruri = require 'qruri'
qs = require 'querystring'
{ make_multisig } = require './lib.coffee'

SATOSHI = 100000000
chain_api_key = '952d0be9540d035cb60f57bbc9b2a00c'

{ a: alice_pub, b: bob_pub, s: contract_script } = qs.parse location.hash[1..]
alice_pub = new Buffer alice_pub, 'base64'
bob_pub = new Buffer bob_pub, 'base64'

{ multisig_addr } = make_multisig contract_script, alice_pub, bob_pub
multisig_qr = qruri 'bitcoin:'+multisig_addr, modulesize: 7, margin: 0

# Update data & bind events
$ ->
	$('.multisig-qr').html """<img src="#{ multisig_qr }">"""
	$('.multisig-addr').text multisig_addr
	$('.contract-script').text contract_script
	$('.run').click run

# Update balance
update_balance = ->
	$.ajax url: 'https://api.chain.com/v2/testnet3/addresses/'+multisig_addr+'?api-key-id='+chain_api_key
	.done (res) ->
		amount = res[0].total.balance / SATOSHI
		$ -> $('.balance').text "#{ amount } BTC"
do update_balance

# Run contract
run = ->
	$.ajax url: '/contract', method: 'post', data: { contract_script, alice_pub, bob_pub }
	.done (res) ->
		console.log res

# Listen for transactions
ws = new WebSocket 'wss://ws.chain.com/v2/notifications'
ws.onopen = (ev) ->
	ws.send JSON.stringify type: 'address', address: multisig_addr, block_chain: 'testnet3'
ws.onmessage = (ev) ->
	data = JSON.parse ev.data
	return unless data?.payload?.type is 'address'

	amount = data.payload.received / SATOSHI
	txid = data.payload.transaction_hash[0...10]
	new PNotify
		title: 'Payment received'
		text: "The contract has just received a payment of #{ amount } BTC (transaction #{ txid }...)."
		styling: 'bootstrap3'
		type: 'success'
	do update_balance
