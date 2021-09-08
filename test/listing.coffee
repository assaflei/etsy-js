fs = require('fs')
nock = require("nock")
should = require("chai").should()
etsyjs = require("../lib/etsyjs")
client = etsyjs.client({
    authType: 'oauth2',
    key: process.env.ETSY_KEY,
    secret: process.env.ETSY_SECRET,
    callbackURL: 'https://f4aa6ccc63c6.eu.ngrok.io/api/etsy/public/etsyauthv2'})

describe "listing", ->

  it "should be able to find a single listing", ->
    nock("https://openapi.etsy.com")
      .get("/v3/application/listings/59759273")
      .replyWithFile(200, __dirname + '/responses/getListing.single.json')

    client.listing(59759273).find (err, body, headers) ->
      body.results[0].listing_id.should.equal 59759273

  it "should be able to find all active listings", ->
    nock("https://openapi.etsy.com")
    .get("/v3/application/listings/active")
    .replyWithFile(200, __dirname + '/responses/listing/findAllListingActive.category.json')

    client.listing().active (err, body, headers) ->
      body.results[0].listing_id.should.be.greaterThan 0

  it "should be able to find all active listings by category", ->
    nock("https://openapi.etsy.com")
    .get("/v3/application/listings/active?category=accessories")
    .replyWithFile(200, __dirname + '/responses/listing/findAllListingActive.category.json')

    params = {category: "accessories"}
    client.listing().active params, (err, body, headers) ->
      body.results[0].listing_id.should.be.greaterThan 0

  it "should be able to find all trending listings", ->
    nock("https://openapi.etsy.com")
    .get("/v3/application/listings/trending")
    .replyWithFile(200, __dirname + '/responses/listing/findAllListingActive.category.json')

    client.listing().trending (err, body, headers) ->
      body.results[0].listing_id.should.be.greaterThan 0

  it "should get listing properties", (done) ->
    # nock("https://openapi.etsy.com")
    # .get("/v3/application/shops/1/listings/1/properties")
    # .replyWithFile(200, __dirname + '/responses/listing/getProperties.json')

    client.listing(821396190).getProperties process.env.ETSY_SHOP, (err, body, headers) ->
    # client.listing(1).getProperties 1, (err, body, headers) ->
      should.exist(body.count)
      done()

  it "should invoke api to create a new listing", (done) ->
    nock("https://openapi.etsy.com")
    .post("/v3/application/shops/1/listings")
    .replyWithFile(201, __dirname + '/responses/listing/createListing.json')

    params = {state: "draft", title: "test"}
    client.listing().create 1, params, (err, body, headers) ->
      body.listing_id.should.equal 1
      done()

  it "should invoke api to upload listing image", (done) ->
    nock("https://openapi.etsy.com")
    .post("/v3/application/shops/1/listings/1/images")
    .replyWithFile(201, __dirname + '/responses/listing/uploadImage.json')

    stream = "the value should be fs.createReadStream('path/to/file')"
    params = {"rank": 1}
    # client.listing(1047491147).uploadListingImage process.env.ETSY_SHOP, fs.createReadStream('e:/temp/img1.jpg'), params, (err, body, headers) ->
    client.listing(1).uploadListingImage 1, stream, params, (err, body, headers) ->
      should.exist(body.listing_image_id)
      done()

  it "should invoke api to update listing inventory", (done) ->
    nock("https://openapi.etsy.com")
    .put("/v3/application/listings/1/inventory")
    .replyWithFile(200, __dirname + '/responses/listing/updateListingInventory.json')

    params = {"param": 1}
    # client.listing(1047491147).uploadListingImage process.env.ETSY_SHOP, fs.createReadStream('e:/temp/img1.jpg'), params, (err, body, headers) ->
    client.listing(1).updateInventory params, (err, body, headers) ->
      should.exist(body.products)
      done()

  it "should invoke api to get listing inventory", (done) ->
    nock("https://openapi.etsy.com")
    .get("/v3/application/listings/1/inventory")
    .replyWithFile(200, __dirname + '/responses/listing/updateListingInventory.json')

    # params = {"param": 1}
    # client.auth('','','token here').listing(1057993675).getInventory params, (err, body, headers) ->
    client.listing(1).getInventory (err, body, headers) ->
      should.exist(body.products)
      done()

  it "should delete listing", (done) ->
    nock("https://openapi.etsy.com")
    .delete("/v3/application/listings/1")
    .replyWithFile(204, __dirname + '/responses/listing/deleteListing.json')

    # client.listing(1047491147).uploadListingImage process.env.ETSY_SHOP, fs.createReadStream('e:/temp/img1.jpg'), params, (err, body, headers) ->
    # client.auth('','','token here').listing(1).delete (err, body, headers) ->
    client.listing(1).delete (err, body, headers) ->
      should.exist(body.result)
      done()
