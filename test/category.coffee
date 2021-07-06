nock = require("nock")
should = require("chai").should()
etsyjs = require("../lib/etsyjs")
client = etsyjs.client({key:'testKey'})

describe "category", ->

  it "should be able to find a single category", (done) ->
    nock("https://api.etsy.com")
      .get("/v3/application/categories/69150467?api_key=testKey")
      .replyWithFile(200, __dirname + '/responses/getCategory.single.json')

    client.category(69150467).find (err, body, headers) ->
      body.results[0].category_name.should.equal "accessories"
      done()

  it "should be able to find all top level categories", (done) ->
    nock("https://api.etsy.com")
      .get("/v3/application/taxonomy/buyer/get?api_key=testKey")
      .replyWithFile(200, __dirname + '/responses/category/findAllTopCategory.json')

    client.category().topLevelCategories (err, body, headers) ->
      body.results.length.should.equal 31
      done()

  it "should be able to find children of a top level category", (done) ->
    nock("https://api.etsy.com")
      .get("/v3/application/taxonomy/categories/69150467?api_key=testKey")
      .replyWithFile(200, __dirname + '/responses/category/findAllTopCategoryChildren.json')

    client.category(69150467).topLevelCategoryChildren (err, body, headers) ->
      body.results.length.should.equal 27
      done()

  # it "should be able to find a category by tag and subtag", ->
  #   nock("https://openapi.etsy.com").get("/v2/categories/69150467?api_key=testKey")
  #   .replyWithFile(200, __dirname + '/responses/findAllTopCategoryChildren.json')
  #   client.category(69150467, '').topLevelCategoryChildren {}, (err, body, headers) ->
  #     body.results[0].category_name.should.equal "category_name"
