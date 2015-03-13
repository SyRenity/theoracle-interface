google = require 'google'
google.lang = 'en'
google.tld ='com'
google.resultPerPage = {rank}
if {time} > Date.now()
	return out null, "Contract not expired yet"
google {keyword}, (err,next,links) ->
	return out err if err?
	console.log 'results', links
	for l in links when ~l.link.indexOf {url}
		return out null, payto {company_address}
	out null, payto {customer_address}
