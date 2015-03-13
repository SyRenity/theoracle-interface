qs = require 'querystring'
qruri = require 'qruri'

$ -> $('form').submit (e) ->
	e.preventDefault()

	$t = $ this
	contract_script = $t.find('[name=contract-script]').val()
	alice_pub = new Buffer $t.find('[name=alice]').val(), 'hex'
	bob_pub = new Buffer $t.find('[name=bob]').val(), 'hex'

	execution_params = a: alice_pub.toString('base64'), b: bob_pub.toString('base64'), s: contract_script
	document.location = '/contract#' + qs.stringify execution_params
