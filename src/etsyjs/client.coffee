# Required modules
FormData = require 'form-data'
querystring = require 'querystring'
request = require 'request'
OAuth = require 'oauth'
util = require 'util'

User = require './user'
Me = require './me'
Category = require './category'
Shop = require './shop'
Search = require './search'
Listing = require './listing'
Address = require './address'
Receipt = require './receipt'

# Specialized error
class HttpError extends Error
  constructor: (@message, @statusCode, @headers) ->

class Client
  constructor: (@options) ->
    # @authType = @options.authType #use oauth or oauth2
    @oauth2AuthPath = 'https://www.etsy.com/oauth/connect'
    @oauth2Scopes = 'email_r profile_r address_r address_w'
    @apiKey = @options.key
    @apiSecret = @options.secret
    @callbackURL = @options.callbackURL
    @request = request

    # if @options.authType and @options.authType == 'oauth'
    @etsyOAuth = new OAuth.OAuth(
      'https://openapi.etsy.com/v2/oauth/request_token?scope=email_r%20profile_r%20profile_w%20address_r%20address_w',
      'https://openapi.etsy.com/v2/oauth/access_token',
      "#{@apiKey}",
      "#{@apiSecret}",
      '1.0',
      "#{@callbackURL}",
      'HMAC-SHA1'
    )
    # else
    @etsyOAuth2 = new OAuth.OAuth2(
      "#{@apiKey}",
      "#{@apiSecret}",
      'https://api.etsy.com',
      "#{@oauth2AuthPath}",
      '/v3/public/oauth/token',
      {"x-api-key":@apiKey}
    )

  # nice helper method to set token and secret for each method call
  # client().auth('myToken', 'mySecret').me().find()
  auth: (token, secret, oa2Token) ->
    @authenticatedToken = token
    @authenticatedSecret = secret
    @oauth2Token = oa2Token
    return this

  me: ->
    new Me(@)

  user: (userId) ->
    new User(userId, @)

  category: (tag) ->
    new Category(tag, @)

  shop: (shopId) ->
    new Shop(shopId, @)

  search: ->
    new Search(@)

  listing: (listingId) ->
    new Listing(listingId, @)

  address: (userId) ->
    new Address(userId, @)

  receipt: (listingId) ->
    new Receipt(@)

  buildUrl: (path = '/', pageOrQuery = null, params...) ->
    if pageOrQuery? and typeof pageOrQuery == 'object'
      query = pageOrQuery
      query.api_key = @apiKey if @apiKey? && not @apiSecret?
    else
      query = {}

    if params.length > 0
      for key, value of params
        if value?
          for valKey, valValue of value 
            query[valKey] = valValue

    query.api_key = @apiKey if @apiKey? && not @apiSecret?
    _url = require('url').format
      protocol: "https:"
      hostname: "api.etsy.com"
      pathname: "/v3/application#{path}"
      query: query

    console.dir "API URL is #{_url} "
    return _url

  handleResponse: (res, body, callback)->
    return callback(new HttpError('Error ' + res.statusCode, res.statusCode,
      res.headers)) if Math.floor(res.statusCode / 100) is 5
    if typeof body == 'string'
      try
        body = JSON.parse(body || '{}')
      catch err
        console.log "Error parsing response: #{body}"
        return callback(err)
    return callback(new HttpError(body.message, res.statusCode,
      res.headers)) if body.message and res.statusCode in [400, 401, 403, 404, 410, 422]

#    console.log util.inspect body.results
    callback null, res.statusCode, body, res.headers

  # api GET requests
  get: (path, params..., callback) ->
    console.log "==> Client get request with params #{params}"
    if @authenticatedToken? and @authenticatedSecret?
      @getAuthenticated path, params..., callback
    else
      @getUnauthenticated path, params..., callback

  # api PUT requests
  put: (path, content, callback) ->
    url = @buildUrl path
    console.log "==> Perform PUT request on #{url} with #{JSON.stringify content}"
    @etsyOAuth.put url, @authenticatedToken, @authenticatedSecret, content,  (err, data, res) =>
      return callback(err) if err
      @handleResponse res, data, callback

  # api POST requests
  post: (path, content, contentType, callback) ->
    url = @buildUrl path
    contentType = if !contentType? then "application/x-www-form-urlencoded" else contentType
    console.log "==> Perform POST request on #{url} with #{JSON.stringify content}"
    @etsyOAuth2._request "POST", url, {'Authorization':@etsyOAuth2.buildAuthHeader(@oauth2Token),'Content-Type':contentType}, querystring.stringify(content), @oauth2Token, (err, data, res) =>
      return callback(err) if err
      @handleResponse res, data, callback


  # api POST multipart form requests (usually file uploads)
  postMultipart: (path, content, callback) ->
    url = new URL(@buildUrl path)
    console.log "==> Perform multipart POST request on #{url} with #{typeof content} content"
    form = new FormData()
    form.append('image', content)
    form.submit({
      protocol: url.protocol,
      host: url.host,
      path: url.pathname,
      headers: {
        'Authorization': @etsyOAuth2.buildAuthHeader(@oauth2Token),
        "x-api-key": @apiKey
      }
    }, (err, res) =>
      return callback(err) if err
      return @handleResponse res, "{\"message\":\"success\"}", callback
    )

  # api DELETE requests
  delete: (path, callback) ->
    url = @buildUrl path
    console.log "==> Perform DELETE request on #{url}"
    @etsyOAuth.delete url, @authenticatedToken, @authenticatedSecret, (err, data, res) =>
      return callback(err) if err
      @handleResponse res, data, callback

  getUnauthenticated: (path, params..., callback) ->
    console.log "==> Perform unauthenticated GET request"
    @request (
      uri: @buildUrl path, params...
      method: 'GET'
    ), (err, res, body) =>
      return callback(err) if err
      @handleResponse res, body, callback

  getAuthenticated: (path, params..., callback) ->
    url = @buildUrl path, params...
    if !@oauth2Token?
      console.log "==> Perform authenticated GET request on #{url}"
      @etsyOAuth.get url, @authenticatedToken, @authenticatedSecret, (err, data, res) =>
        return callback(err) if err
        @handleResponse res, data, callback
    else
      console.log "==> Perform authenticated GET request on #{url}"
      @etsyOAuth2.useAuthorizationHeaderforGET(true)
      @etsyOAuth2.get url, @oauth2Token, (err, data, res) =>
        return callback(err) if err
        @handleResponse res, data, callback

  requestToken: (callback) ->
    @etsyOAuth.getOAuthRequestToken (err, oauth_token, oauth_token_secret) ->
      console.log "==> Retrieving the request token"
      return callback(err) if err
      loginUrl = arguments[3].login_url
      auth =
        token: oauth_token
        tokenSecret: oauth_token_secret
        loginUrl: loginUrl
      callback null, auth

  requestTokenOA2: (callback) ->
    crypto= require('crypto')
    stateHash = crypto.randomBytes(20).toString('hex');
    codeVerifier = crypto.randomBytes(32).toString('base64')
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/\=/g, '');
    codeChallenge = crypto.createHash('sha256').update(codeVerifier).digest().toString('base64')
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/\=/g, '');
    authUrl = @buildUrl @oauth2AuthPath, {
      response_type: 'code',
      client_id: @apiKey,
      redirect_uri: @callbackURL,
      scope: @oauth2Scopes,
      state: stateHash,
      code_challenge: codeChallenge,
      code_challenge_method: 'S256'
    }
    authUrl = authUrl.replace 'https://openapi.etsy.com/v2', ''
    result = {
      loginUrl: authUrl,
      state: stateHash,
      verifier: codeVerifier,
      code_challenge: codeChallenge
    }
    callback null, result
    # @etsyOAuth2.get authUrl, null, (err, data, res) =>
    #   console.log "==> Retrieving the request token"
    #   return callback(err) if err
    #   loginUrl = res.headers.location
    #   auth =
    #     loginUrl: loginUrl
    #   callback null, auth

  accessToken: (token, secret, verifier, callback) ->
    @etsyOAuth.getOAuthAccessToken token, secret, verifier, (err, oauth_access_token, oauth_access_token_secret, results) ->
      console.log "==> Retrieving the access token"
      return callback(err) if err
      accessToken =
        token: oauth_access_token
        tokenSecret: oauth_access_token_secret

      callback null, accessToken

  accessTokenOA2: (code, codeVerifier, grantType, callback) ->
    grantType = if !grantType? then "authorization_code" else "refresh_token"
    params = {
      grant_type: grantType,
      redirect_uri: @callbackURL
      code_verifier: codeVerifier
    }
    @etsyOAuth2.getOAuthAccessToken code, params, (err, oauth_access_token, refresh_token, results) ->
      console.log "==> Retrieving the access token"
      return callback(err) if err
      accessToken =
        token: oauth_access_token
        refreshToken: refresh_token

      callback null, accessToken
  ###
  Allows for adding scope to the requests.
  (ex: transactions_r, listings_r, etc..)
  @author : httpNick
  ###
  addScope: (newScope) ->
    if this.etsyOAuth._requestUrl.indexOf(newScope) == -1
      this.etsyOAuth._requestUrl += "%20#{newScope}"
    else
      this.etsyOAuth._requestUrl

    if @oauth2Scopes.indexOf(newScope) == -1
      @oauth2Scopes += " #{newScope}"

module.exports = (apiKey, options) ->
  new Client(apiKey, options)
