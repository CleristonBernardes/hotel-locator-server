_ = require 'underscore'

get_parameters = (req) ->
  _.extend req.params, req.query, req.body


module.exports = {
  get_parameters
}
