request = require 'superagent'
request.get 'https://api.bitcoinaverage.com/all', (err, res) ->
	
	d = new Date
	if {expiration_date} < d.getTime
		return out null
0
	val = res.body.USD.averages.last
	if val < {current_price}
		out null, payto {put_trader_address}
	else
		out null, payto {call_trader_address}	


