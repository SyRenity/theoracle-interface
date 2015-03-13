qs = require 'querystring'
qruri = require 'qruri'
{ make_multisig } = require './lib.coffee'

$ -> $('form').submit (e) ->
	e.preventDefault()

	$t = $ this
	contract_script = $t.find('[name=contract-script]').val()
	alice_pub = new Buffer $t.find('[name=alice]').val(), 'hex'
	bob_pub = new Buffer $t.find('[name=bob]').val(), 'hex'

	{ multisig_addr } = make_multisig contract_script, alice_pub, bob_pub

	multisig_qr = qruri 'bitcoin:' + multisig_addr

	execution_params = a: alice_pub.toString('base64'), b: bob_pub.toString('base64'), s: contract_script
	document.location = '/contract#' + qs.stringify execution_params
