exports = module.exports = ->
	google = require 'google'
	google.lang = 'en'
	google.tld ='com'
	google.resultPerPage = 10
		
	var d = new Date
	if {time} < d.getTime
		return out null
	
	google keyword, (err,next,links) ->
		for l in links when l.link.indexOf {url}
			return out null, payto {
	out null, payto {customer_address}	
				

