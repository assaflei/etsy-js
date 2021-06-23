nock = require("nock")
should = require("chai").should()
expect = require("chai").expect
etsyjs = require("../lib/etsyjs")
client_oa1 = etsyjs.client({
    authType: 'oauth',
    key: process.env.ETSY_KEY,
    secret: process.env.ETSY_SECRET,
    callbackURL: 'https://f4aa6ccc63c6.eu.ngrok.io/api/etsy/public/etsyauthv2'})
client_oa2 = etsyjs.client({
    authType: 'oauth2',
    state: 'state',
    key: process.env.ETSY_KEY,
    secret: process.env.ETSY_SECRET,
    callbackURL: 'https://f4aa6ccc63c6.eu.ngrok.io/api/etsy/public/etsyauthv2'})

describe "client", -> 

  it "should be able to get OAuth connection token", (done) ->
    client_oa1.requestToken (err, body, headers) ->
      should.exist(body.token);
      done()
  it "should be able to get OAuth2 connection token", (done) ->
    client_oa2.requestTokenOA2 (err, body) ->
      should.exist(body.loginUrl);
      expect(body.loginUrl).to.have.string('connect');
      done()
  it "should get OAuth2 access token", (done) ->
    nock("https://api.etsy.com")
      .post("/v3/public/oauth/token")
      .replyWithFile(200, __dirname + "/responses/client/accessTokenOA2.json")
    client_oa2.accessTokenOA2 "code", "verifier", undefined, (err, body) ->
      should.exist(body.token);
      done()
  it "should get OAuth2 refreshed access token", (done) ->
    nock("https://api.etsy.com")
      .post("/v3/public/oauth/token")
      .replyWithFile(200, __dirname + "/responses/client/accessTokenOA2.json")
    client_oa2.accessTokenOA2 "code", "verifier", "refresh_token", (err, body) ->
      should.exist(body.token);
      done()