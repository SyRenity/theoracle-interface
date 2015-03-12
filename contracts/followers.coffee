module.exports = exports = ->
	
	Twitter = require 'twitter'
	client = new Twitter ({			
		consumer_key: 'Zkvg1aJHjC1X1Sk6fVLCr5Cg4',
		consumer_secret: '3Hs3y36x66p2rVXQgNh6vQknJqTogPqrYHau5EMmt6b2RavfKS',
		access_token_key: '3072024320-yjgI52ndB8Yd12fck1Ton4e3lvHQFKnt6GBCFbC',
		access_token_secret: 'gsme9XrGROyFCqaKW5ou4SrTInCOOixcyE6QbuW4UefOv'
		access_token_secret:'gsme9XrGROyFCqaKW5ou4SrTInCOOixcyE6QbuW4UefOv'})
	params = {}
	client.get 'search/tweets.json?cursor=-1&screen_name=bitrated&count=5000', params, (err,tweets,res) ->
		console.log(res)
