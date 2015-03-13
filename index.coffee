express = require 'express'
stylus = require 'stylus'
browserify = require 'browserify-middleware'
request = require 'superagent'

app = express()

app.set 'view engine', 'jade'

app.use stylus.middleware
	src: __dirname + '/public'
	dest: __dirname + '/public'

app.use '/public', express.static __dirname + '/public'

app.get '/script/new.js', browserify __dirname+'/script/new.coffee', extension: [ '.coffee' ]

app.get '/', (req, res, next) ->
  res.render 'mainform'

app.post '/', (req, res, next) ->
		
app.get '/tx/:txid', (req, res, next) ->
	req.params.txid

app.get '/followers', (req, res, next) ->
	res.render 'followersform'

app.get '/google', (req, res, next) ->
	res.render 'google'

app.get '/bitcoin_binary', (req, res, next) ->
	expiration_date = new Date(Date.now()+30000).toString()

	request.get 'https://api.bitcoinaverage.com/all', (err, resp) ->
		res.render 'bitcoinbinaryform',
		  {current_value: resp.body.USD.averages.last, expiration_date: expiration_date}
	
server = app.listen 3000,->
	console.log "Server started"


