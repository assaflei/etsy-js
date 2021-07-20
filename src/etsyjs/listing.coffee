class Listing

  constructor: (@listingId, @client) ->

  # Retrieves listings by id
  # '/listings/:listing_id' GET
  find: (params..., cb) ->
    @client.get "/listings/#{@listingId}", params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get listings error'))
      else
        cb null, body, headers

  # Finds all active Listings.
  # '/listings/active' GET
  active: (params..., cb) ->
    @client.get "/listings/active", params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get active listings error'))
      else
        cb null, body, headers

  # Collects the list of listings used to generate the trending listing page
  # '/listings/trending' GET
  trending: (params..., cb) ->
    @client.get "/listings/trending", params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get trending listings error'))
      else
        cb null, body, headers

  # Collects the list of interesting listings
  # '/listings/interesting' GET
  interesting: (params..., cb) ->
    @client.get "/listings/interesting", params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get interesting listings error'))
      else
        cb null, body, headers

  # Retrieves listings by id
  # '/shops/:shop_id/listings/:listing_id/properties' GET
  getProperties: (shop, cb) ->
    @client.get "/shops/#{shop}/listings/#{@listingId}/properties", (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get listings error'))
      else
        cb null, body, headers

  # Creates a new listing
  # /listings POST
  create: (shop, listing, cb) ->
    @client.post "/shops/#{shop}/listings", listing, null, (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 201
        cb(new Error('Create a new listing error'))
      else
        cb null, body, headers

  # Updates listing details
  # /listings/:listing_id PUT
  update: (listing, cb) ->
    @client.put "/listings/#{@listingId}", listing, (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Update listing error'))
      else
        cb null, body, headers

  # Updates listing details
  # /listings/:listing_id PUT
  updateInventory: (listing, cb) ->
    @client.put "/listings/#{@listingId}/inventory", JSON.stringify(listing), "application/json", (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Update listing quantity error'))
      else
        cb null, body, headers

  # Updates listing details
  # /listings/:listing_id/variation-images POST
  updateVariationImages: (shop, varImagesData, cb) ->
    @client.post "/shops/#{shop}/listings/#{@listingId}/variation-images", JSON.stringify(varImagesData), "application/json", (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Update listing variation images error'))
      else
        cb null, body, headers

  # Updates listing details
  # /shops/:shop_id/listings/:listing_id/images POST
  uploadListingImage: (shop, imageData, params..., cb) ->
    @client.postMultipart "/shops/#{shop}/listings/#{@listingId}/images", imageData, params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 201
        cb(new Error('Update listing images error'))
      else
        cb null, body, headers
module.exports = Listing