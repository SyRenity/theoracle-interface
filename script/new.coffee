qs = require 'querystring'
qruri = require 'qruri'

$ -> $('form').submit (e) ->
	e.preventDefault()

	$t = $ this
	contract_script = get_script $t
	alice_pub = new Buffer $t.find('[name=alice]').val(), 'hex'
	bob_pub = new Buffer $t.find('[name=bob]').val(), 'hex'

	execution_params = a: alice_pub.toString('base64'), b: bob_pub.toString('base64'), s: contract_script
	document.location = '/contract#' + qs.stringify execution_params

get_script = ($t) ->
	if contract_script = $t.find('[name=contract-script]').val()
		contract_script
	else if script_tmpl = $t.find('[name=script-tmpl]').val()
		contract_script = script_tmpl
		$t.find(':input[data-tmpl-name]').each ->
			$input = $ this
			name = $input.data 'tmpl-name'
			val = $input.val()
			if $input.data('tmpl-num')? then val = +val
			else if $input.data('tmpl-time')? then val = +new Date val
			val = JSON.stringify val
			contract_script = contract_script.replace ///\{#{ name }\}///g, val
		contract_script
	else throw new Error 'Cannot figure out contract'


