module.exports = exports = ->

	request = require 'superagent'
	request.get 'https://api.bitcoinaverage.com/all', (err, res) ->
		if res.body.USD.averages.last > {current_price}				
			out null, payto {company_address}
		else
			out nul, payto {customer_address}	


