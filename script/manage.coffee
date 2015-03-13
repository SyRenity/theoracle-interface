qruri = require 'qruri'
qs = require 'querystring'
{ make_multisig } = require './lib.coffee'
show_tx = require './show-tx.coffee'

SATOSHI = 100000000
chain_api_key = process.env.CHAIN_API_KEY

{ a: alice_pub, b: bob_pub, s: contract_script } = qs.parse location.hash[1..]
alice_pub = new Buffer alice_pub, 'base64'
bob_pub = new Buffer bob_pub, 'base64'

{ multisig_addr, multisig_script } = make_multisig contract_script, alice_pub, bob_pub
multisig_qr = qruri 'bitcoin:'+multisig_addr, modulesize: 7, margin: 0

# Update data & bind events
$ ->
	$('.multisig-qr').html """<img src="#{ multisig_qr }">"""
	$('.multisig-addr').text multisig_addr
	$('.contract-script').text contract_script
	$('.run').click run

# Update balance
balance = 0
update_balance = ->
	$.ajax url: 'https://api.chain.com/v2/testnet3/addresses/'+multisig_addr+'?api-key-id='+chain_api_key
	.done (res) ->
		balance = res[0].total.balance
		$('.balance').text "#{ balance/SATOSHI } BTC"
$ update_balance

# Run contract
run = ->
	$.ajax url: '/contract', method: 'post', data: { contract_script, alice_pub: alice_pub.toString('hex'), bob_pub: bob_pub.toString('hex') }
	.done (res) ->
		switch res.type
			when 'msg'
				new PNotify
					title: 'Contract not completed'
					text: res.message
					styling: 'bootstrap3'
					type: 'info'
					delay: 500000
			when 'tx'
				show_tx balance, res.tx, multisig_script
			else
				throw new Error 'Unknown oracle response type'

# Listen for transactions
ws = new WebSocket 'wss://ws.chain.com/v2/notifications'
ws.onopen = (ev) ->
	ws.send JSON.stringify type: 'address', address: multisig_addr, block_chain: 'testnet3'
ws.onmessage = (ev) ->
	data = JSON.parse ev.data
	return unless data?.payload?.type is 'address'
	return if data.payload.confirmations > 0 # only new txs

	txid = data.payload.transaction_hash[0...10]

	if data.payload.received
		amount = data.payload.received / SATOSHI
		new PNotify
			title: 'Payment received'
			text: "The contract has just received a payment of #{ amount } BTC (transaction #{ txid }...)."
			styling: 'bootstrap3'
			type: 'success'
			delay: 5000
	if data.payload.sent
		amount = data.payload.sent / SATOSHI
		new PNotify
			title: 'Funds spent'
			text: "The contract has just spent #{ amount } BTC (transaction #{ txid }...)."
			styling: 'bootstrap3'
			type: 'info'
			delay: 5000
	do update_balance
