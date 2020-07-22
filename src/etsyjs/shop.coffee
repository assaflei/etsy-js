class Shop

  constructor: (@shopId, @client) ->

  # Retrieves a Shop by id
  # '/shops/:shop_id' GET
  find: (cb) ->
    @client.get "/shops/#{@shopId}", (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get shop error'))
      else
        cb null, body, headers

  # Retrieves Listings associated to a Shop that are featured
  # '/shops/:shop_id/listings/featured' GET
  featuredListings: ({token, secret, limit, offset}, cb) ->
    params = {}
    params.limit = limit if limit?
    params.offset = offset if offset?
    @client.get "/shops/#{@shopId}/listings/featured", token, secret, params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get featured listings error'))
      else
        cb null, body, headers

  # Retrieves Listings associated to a Shop that are active
  # '/shops/:shop_id/listings/active' GET
  activeListings: ({token, secret, limit, offset}, cb) ->
    params = {}
    params.limit = limit if limit?
    params.offset = offset if offset?
    @client.get "/shops/#{@shopId}/listings/active", token, secret, params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get active listings error'))
      else
        cb null, body, headers

  # Retrieves Listings associated to a Shop that are drafts
  # '/shops/:shop_id/listings/draft' GET
  draftListings: ({token, secret, limit, offset}, cb) ->
    params = {}
    params.limit = limit if limit?
    params.offset = offset if offset?
    @client.get "/shops/#{@shopId}/listings/draft", token, secret, params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get draft listings error'))
      else
        cb null, body, headers
        
  # Retrieves Listings associated to a Shop that are expired
  # '/shops/:shop_id/listings/expired' GET
  expiredListings: ({token, secret, limit, offset}, cb) ->
    params = {}
    params.limit = limit if limit?
    params.offset = offset if offset?
    @client.get "/shops/#{@shopId}/listings/expired", token, secret, params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get expired listings error'))
      else
        cb null, body, headers
        
  # Retrieves Listings associated to a Shop that are inactive
  # '/shops/:shop_id/listings/inactive' GET
  inactiveListings: ({token, secret, limit, offset}, cb) ->
    params = {}
    params.limit = limit if limit?
    params.offset = offset if offset?
    @client.get "/shops/#{@shopId}/listings/inactive", token, secret, params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get inactive listings error'))
      else
        cb null, body, headers
module.exports = Shop