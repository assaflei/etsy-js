util = require('util')

class Receipt

  constructor: (@client) ->

  # Retrieves receipts by shop id
  # '/shops/:shop_id/receipts' GET
  findByShop: (shopId, params..., {token, secret, limit, offset}, cb) ->
    params = if !params? then {} else params
    params.push { limit: limit } if limit?
    params.push { offset: offset } if offset?
    params.push { min_last_modified: min_last_modified } if min_last_modified?
    params.push { max_last_modified: max_last_modified } if max_last_modified?
    @client.get "/shops/#{shopId}/receipts", token, secret, params..., (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get shop receipts error'))
      else
        cb null, body, headers

  # Retrieves receipts by shop id
  # '/receipts/:receipt_id' GET
  find: (receiptId, cb) ->
    @client.get "/receipts/#{@receiptId}", (err, status, body, headers) ->
      return cb(err) if err
      if status isnt 200
        cb(new Error('Get receipt error'))
      else
        cb null, body, headers

module.exports = Receipt
