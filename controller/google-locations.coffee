google_locations  =  require 'google-locations'
googleplaces    = require 'googleplaces'
config            = require 'config'

locator = new google_locations(config.API.google_locations)
photo_locator = new googleplaces(config.API.google_locations)

search_location = ({keyword, location}, done) ->
  query = {keyword, location}
  query.rankby = "distance"
  locator.search query, done

search_photos = ({reference, maxheight, maxwidth}, done) ->
  query = {photoreference: reference, maxheight, maxwidth}
  photo_locator.imageFetch query, done

search_details = ({id}, done) ->
  locator.details {placeid: id}, done


module.exports = {
  search_location
  search_photos
  search_details
}
