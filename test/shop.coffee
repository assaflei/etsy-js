nock = require("nock")
should = require("chai").should()
etsyjs = require("../lib/etsyjs")
client = etsyjs.client({
    authType: 'oauth2',
    key: process.env.ETSY_KEY,
    secret: process.env.ETSY_SECRET,
    callbackURL: 'https://f4aa6ccc63c6.eu.ngrok.io/api/etsy/public/etsyauthv2'})

describe "shop", ->

  it "should be able to find a single shop", (done) ->
    nock("https://openapi.etsy.com")
      .get("/v3/application/shops/boutiqueviolet")
      .replyWithFile(200, __dirname + '/responses/getShop.single.json')

    client.shop("boutiqueviolet").find (err, body, headers) ->
      body.results[0].shop_name.should.equal "littletjane"
      done()

  it "should be able to find shop's shipping profiles", (done) ->
    nock("https://openapi.etsy.com")
      .get("/v3/application/shops/boutiqueviolet/shipping-profiles")
      .replyWithFile(200, __dirname + '/responses/shop/getShippingProfiles.json')

    # client.auth('','','320056284.nxx9dJDM9zO0FI5ck7484XiLbDUVFUjQ8dmWznFFvGODFriJ03RFntKxnKj32MMuAuBv7t5wXggAPFzcgNezgwO6df').shop(process.env.ETSY_SHOP).shippingProfiles (err, body, headers) ->
    client.shop("boutiqueviolet").shippingProfiles (err, body, headers) ->
      should.exist(body.results)
      done()