express 							= require "express"
config	 							= require "config"
bodyParser 						= require "body-parser"
google_locations					  	= require './presenter/google-locations'
utils						= require './utils'


app = express()
app.use bodyParser.urlencoded { extended: false }
app.use bodyParser.json()
app.use bodyParser.json { type: 'application/vnd.api+json' }
app.use (err, req, res, next) ->
	res.header('Access-Control-Allow-Origin', 'example.com')
	res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
	res.header('Access-Control-Allow-Headers', 'Content-Type')
	console.log "err", err
	erro = {"error": "Could not persist the card"}
	handleResponse res, 400, erro

app.get '/', (req, res) ->
	res.setHeader 'Content-Type', 'text/html'
	html = "hello world"
	res.end html

app.get '/nearest', (req, res) ->
	google_locations.search_nearest_by_keyword utils.get_parameters(req), (err, locations) ->
		if err?
			handleResponse res, 400, err
		else
			handleResponse res, 200, locations

app.get '/details/:id', (req, res) ->
	google_locations.get_location_details utils.get_parameters(req), (err, details) ->
		if err?
			handleResponse res, 400, err
		else
			handleResponse res, 200, details

server = app.listen (process.env.PORT ||config.server.port || 8080), () ->
  console.log "Service running #{process.env.PORT ||config.server.port || 8080}...."


handleResponse = (res, code, exchange) ->
	console.log "exchange", exchange
	res.status(code || 500).json(exchange)
