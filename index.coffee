express = require 'express'
stylus = require 'stylus'

app = express()

app.set 'view engine', 'jade'
app.use stylus.middleware
	src: __dirname + '/public'
	dest: __dirname + '/public'

app.use '/public', express.static __dirname + '/public'

app.get '/', (req, res, next) ->	
  res.render 'mainform'

app.post '/', (req, res, next) ->
		
app.get '/tx/:txid', (req, res, next) ->
	req.params.txid

app.get '/followers', (req, res, next) ->
	res.render 'followersform'

app.get '/bitcoin_binary', (req, res, next) ->
	res.render 'bitcoinbinaryform'

server = app.listen 3000,->
	console.log "Server started"


