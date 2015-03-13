exports = module.exports = ->
	google = require 'google'
	google.lang = 'en'
	google.tld ='com'
	google.resultPerPage = 10
		
	var d = new Date
	if {time} < d.getTime
		return out null
	
	google keyword, (err,next,links) ->
		for l in links when l.link.indexOf {url} not -1
			return out null, payto {company_address}
	out null, payto {customer_address}	
				

