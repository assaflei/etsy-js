fs = require('fs')
nock = require("nock")
should = require("chai").should()
etsyjs = require("../lib/etsyjs")
client = etsyjs.client({
    authType: 'oauth2',
    key: process.env.ETSY_KEY,
    secret: process.env.ETSY_SECRET,
    callbackURL: 'https://f4aa6ccc63c6.eu.ngrok.io/api/etsy/public/etsyauthv2'})

describe "receipt", ->

  it "should be able to update shipping details", (done) ->
    nock("https://openapi.etsy.com")
      .post("/v3/application/shops/1/receipts/2/tracking")
      .replyWithFile(200, __dirname + '/responses/receipt/createReceiptShipment.json')

    client.receipt().updateShipping 1, 2, {"tracking_code": "", "carrier_name": "", "send_bcc": false}, (err, body, headers) ->
      body.receipt_id.should.equal 1
      done()
