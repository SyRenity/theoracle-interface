request = require 'superagent'
request.get 'https://api.bitcoinaverage.com/all', (err, res) ->
	
	if {expiration_date} > Date.now()
		return out null, 'Option hasnt expired yet'

	val = res.body.USD.averages.last
	if val < {current_price}
		out null, payto {put_trader_address}
	else
		out null, payto {call_trader_address}	


