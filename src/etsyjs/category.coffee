class Category

  constructor: (@tag, @client) ->

  # Retrieves a top-level Category by tag
  # '/categories/:tag' GET
  find: (cb) ->
    @client.get "/categories/#{@tag}", (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get categories error'))
      else
        cb null, body, headers

  # Retrieves all top-level Categories
  # '/seller-taxonomy/nodes' GET
  topLevelCategories: (cb) ->
    @client.get "/seller-taxonomy/nodes", (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get top level categories error'))
      else
        cb null, body, headers

  # Retrieves children of a top-level Category by tag
  # '/taxonomy/categories/:tag' GET
  topLevelCategoryChildren: (cb) ->
    @client.get "/taxonomy/categories/#{@tag}", (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get categories error'))
      else
        cb null, body, headers

  # Retrieves categories properties
  # '/seller-taxonomy/nodes/:taxonomy_id/properties' GET
  categoryProperties: (taxonomyId, cb) ->
    @client.get "/seller-taxonomy/nodes/#{taxonomyId}/properties", (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get category properties error'))
      else
        cb null, body, headers

# Retrieves a top-level Category by tag
# '/categories/:tag' GET
#  subCategory: (subtag, {token, secret}, cb) ->
#    @client.get "/categories/#{@tag}/subtag", token, secret, (err, status, body, headers) ->
#      return cb(err) if err
#      if status isnt 200
#        cb(new Error('Get categories error'))
#      else
#        cb null, body, headers

module.exports = Category