request = require 'superagent'
request.get 'https://api.bitcoinaverage.com/all', (err, res) ->
	
	var d = new Date
	if {time} < d.getTime
		return out null

	val = res.body.USD.averages.last
	if ({option_type} is "put" and val < {current_price}) or ({option_type} is "call" and val > {current_price})
		out null, payto {company_address}
	else
		out null, payto {customer_address}	


