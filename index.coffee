express = require 'express'
stylus = require 'stylus'

app = express()
app.set 'view engine', 'jade'

app.use "/public", express.static __dirname + '/public'

app.get '/', (req, res, next) ->	
  res.render 'mainform'

app.post '/', (req, res, next) ->
	
app.get '/tx/:txid', (req, res, next) ->
	req.params.txid

server = app.listen 3000,->
	console.log "Server started"


