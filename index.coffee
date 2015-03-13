express = require 'express'
stylus = require 'stylus'
iferr = require 'iferr'
browserify = require 'browserify-middleware'
request = require 'superagent'

ORACLE_URL = process.env.ORACLE_URL

using = (ctx, fn) -> fn.call ctx

using express(), ->
	@set 'view engine', 'jade'
	@set 'port', process.env.PORT or 3000

	@use require('body-parser').urlencoded extended: false
	@use stylus.middleware
		src: __dirname + '/public'
		dest: __dirname + '/public'

	@use '/public', express.static __dirname + '/public'

	@get '/script/new.js', browserify __dirname+'/script/new.coffee', extension: [ '.coffee' ]
	@get '/script/manage.js', browserify __dirname+'/script/manage.coffee', extension: [ '.coffee' ]

	@get '/', (req, res, next) -> res.render 'mainform'
	[ 'google', 'contract' ].forEach (page) =>
		@get '/'+page, (req, res) -> res.render page

	@get '/bitcoin_binary', (req, res, next) ->
		request.get 'https://api.bitcoinaverage.com/all', iferr next, (resp) ->
			res.render 'bitcoinbinaryform',
				current_value: resp.body.USD.averages.last
				expiration_date: new Date(Date.now()+30000).toString()

	@get '/followers', (req, res, next) ->
		res.render 'followers',
				expiration_date: new Date(Date.now()+30000).toString()

	@post '/contract', (req, res, next) ->
		console.log 'req to oracle', req.body
		request.post ORACLE_URL
			.send req.body
			.end iferr next, (resp) ->
				console.log 'resp from oracle', resp.body
				return next resp.body or resp.error if resp.error
				res.send resp.body

	@listen @settings.port, =>
		console.log "Server started on port #{ @settings.port }"
