google_locations_controller  = require '../controller/google-locations'
# _                            = require 'underscore'
async                        = require 'async'

search_nearest_by_keyword = ({keyword, lat, long}, done) ->
  return done null, {error:"Inform the keyword"} unless keyword?
  return done null, {error:"Inform the location"} unless lat? && long?
  location = [lat, long]
  google_locations_controller.search_location {keyword, location}, (err, locations) ->
    formated_result = []
    for result, index in locations.results
      if index < 5
        formated_result.push({
          id:       result.place_id
          location: result.geometry.location
          name:     result.name
          photos:   result.photos
          rating:   result.rating
        })

    async.eachSeries formated_result, search_location_photo, (err) ->
      done err, formated_result


search_location_photo = (result, done) ->
  return done null unless result?.photos?.length > 0
  ref = result.photos[0]
  query = {reference: ref.photo_reference, maxheight: ref.height, maxwidth: ref.width}
  google_locations_controller.search_photos query, (err, photo) ->
    # console.log "photo", photo.getUrl({'maxWidth': 35, 'maxHeight': 35})
    result.photo = photo
    result.photos = undefined
    done err

get_location_details = (params, done) ->
  google_locations_controller.search_details params, (err, details) ->
    return done err if err?
    formated_result =
      name:                   details.result?.name
      formatted_address:      details.result?.formatted_address
      formatted_phone_number: details.result?.formatted_phone_number
      website:                details.result?.website
      types:                  details.result?.types
      reviews:                details.result?.reviews
    done err, formated_result



module.exports = {
  search_nearest_by_keyword
  get_location_details
}
