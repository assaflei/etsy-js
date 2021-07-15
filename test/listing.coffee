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
    nock("https://api.etsy.com")
      .get("/v3/application/listings/59759273")
      .replyWithFile(200, __dirname + '/responses/getListing.single.json')

    client.listing(59759273).find (err, body, headers) ->
      body.results[0].listing_id.should.equal 59759273

  it "should be able to find all active listings", ->
    nock("https://api.etsy.com")
    .get("/v3/application/listings/active")
    .replyWithFile(200, __dirname + '/responses/listing/findAllListingActive.category.json')

    client.listing().active (err, body, headers) ->
      body.results[0].listing_id.should.equal 69065674

  it "should be able to find all active listings by category", ->
    nock("https://api.etsy.com")
    .get("/v3/application/listings/active?category=accessories")
    .replyWithFile(200, __dirname + '/responses/listing/findAllListingActive.category.json')

    params = {category: "accessories"}
    client.listing().active params, (err, body, headers) ->
      body.results[0].listing_id.should.equal 69065674

  it "should be able to find all trending listings", ->
    nock("https://api.etsy.com")
    .get("/v3/application/listings/trending")
    .replyWithFile(200, __dirname + '/responses/listing/findAllListingActive.category.json')

    client.listing().trending (err, body, headers) ->
      body.results[0].listing_id.should.equal 69065674

  it "should invoke api to create a new listing", (done) ->
    nock("https://api.etsy.com")
    .post("/v3/application/shops/1/listings")
    .replyWithFile(201, __dirname + '/responses/listing/createListing.json')

    params = {state: "draft", title: "test"}
    client.listing().create 1, params, (err, body, headers) ->
      body.listing_id.should.equal 1
      done()

  it "should invoke api to upload listing image", (done) ->
    nock("https://api.etsy.com")
    .post("/v3/application/shops/1/listings/1/images")
    .replyWithFile(201, __dirname + '/responses/listing/uploadImage.json')

    stream = "the value should be fs.createReadStream('path/to/file')"
    params = {"rank": 1}
    # client.listing(1047491147).uploadListingImage process.env.ETSY_SHOP, fs.createReadStream('e:/temp/img1.jpg'), params, (err, body, headers) ->
    client.listing(1).uploadListingImage 1, stream, params, (err, body, headers) ->
      body.message.should.equal "success"
      done()
