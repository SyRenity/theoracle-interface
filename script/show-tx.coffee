{ Transaction } = require 'btc-transaction'
coininfo = require 'coininfo'
coinstring = require 'coinstring'
sign_multisig = require './sign-multisig.coffee'
tmpl = require '../views/tx.jade'

chain_api_key = process.env.CHAIN_API_KEY
currency = process.env.CURRENCY
{ versions } = coininfo currency

show_tx = (total_in, tx, multisig_script) ->
	tx = new Buffer tx, 'hex' if typeof tx is 'string'
	tx = Transaction.deserialize tx if Buffer.isBuffer tx

	total_out = 0
	recipients = tx.outs.map (out) ->
		amount = bytes_to_num out.value
		total_out += amount

		address: script_to_addr out.script
		amount: amount

	tx_fees = total_in - total_out

	$el = $ tmpl { total_in, tx_fees, recipients }
		.modal()

	$el.find('.sign').click ->
		try privkey = coinstring.decode $el.find('[name=privkey]').val(), versions.private
		catch err then return alert 'Invalid private key'

		try	sign_multisig privkey, tx, multisig_script
		catch err then return alert err

		rawtx = new Buffer(tx.serialize()).toString 'hex'
		$.ajax
			method: 'post'
			url:'https://api.chain.com/v2/testnet3/transactions/send?api-key-id='+chain_api_key
			contentType : 'application/json'
			data: JSON.stringify signed_hex: rawtx
		.done (res) ->
			if res.transaction_hash
				prompt 'Success! The txid is:', res.transaction_hash
			else
				alert 'Something bad happened :('


bytes_to_num = (bytes) ->
	if bytes.length then bytes[0] + 256 * bytes_to_num bytes.slice 1
	else 0

script_to_addr = (script) ->
	switch script.getOutType()
		when 'pubkeyhash' then coinstring.encode script.chunks[2], versions.public
		when 'scripthash' then coinstring.encode script.chunks[1], versions.scripthash
		else throw new Error 'Unknown address type'

module.exports = show_tx
