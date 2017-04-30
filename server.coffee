express 							= require "express"
config	 							= require "config"
bodyParser 						= require "body-parser"
google_locations					  	= require './presenter/google-locations'
utils						= require './utils'


app = express()

app.use (req, res, next) ->
  res.header('Access-Control-Allow-Origin', '*')
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With')
  if ('OPTIONS' == req.method)
    res.send 200
  else
    next()
app.use bodyParser.urlencoded { extended: false }
app.use bodyParser.json()
app.use bodyParser.json { type: 'application/vnd.api+json' }
app.use (err, req, res, next) ->
	erro = {"error": "Could not persist the card"}
	handleResponse erro, null, res

app.get '/', (req, res) ->
	res.setHeader 'Content-Type', 'text/html'
	html = "Hotel locator server"
	res.write html

app.get '/nearest', (req, res) ->
	google_locations.search_nearest_by_keyword utils.get_parameters(req), (err, locations) ->
		handleResponse err, locations, res

app.get '/details/:id', (req, res) ->
	google_locations.get_location_details utils.get_parameters(req), (err, details) ->
		handleResponse err, details, res

server = app.listen (process.env.PORT || config.server.port || 8080), () ->
  console.log "Service running #{process.env.PORT || config.server.port || 8080}...."


handleResponse = (err, result, res) ->
	if err?
		res.status(400).json(err)
	else
		res.status(200).json(result)
