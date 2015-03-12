module.exports = exports = ->
	
	Twitter = require 'twitter'
	client = new Twitter 
		consumer_key: 'Zkvg1aJHjC1X1Sk6fVLCr5Cg4'
		consumer_secret: '3Hs3y36x66p2rVXQgNh6vQknJqTogPqrYHau5EMmt6b2RavfKS'
		access_token_key: '3072024320-yjgI52ndB8Yd12fck1Ton4e3lvHQFKnt6GBCFbC'
		access_token_secret: 'gsme9XrGROyFCqaKW5ou4SrTInCOOixcyE6QbuW4UefOv'
		access_token_secret:'gsme9XrGROyFCqaKW5ou4SrTInCOOixcyE6QbuW4UefOv'
	params = screen_name: {twitter_user}
	client.get 'users/show', params, (err, user, res) ->
		return out err if err
		if user.followers_count > {desired_followers}
			out null, payto {company_address}
		else
			out nul, payto {customer_address}	
