(function() {
  var Shop,
    __slice = [].slice;

  Shop = (function() {
    function Shop(shopId, client) {
      this.shopId = shopId;
      this.client = client;
    }

    Shop.prototype.find = function(cb) {
      return this.client.get("/shops/" + this.shopId, function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get shop error'));
        } else {
          return cb(null, body, headers);
        }
      });
    };

    Shop.prototype.featuredListings = function(_arg, cb) {
      var limit, offset, params, secret, token, _ref;
      token = _arg.token, secret = _arg.secret, limit = _arg.limit, offset = _arg.offset;
      params = {};
      if (limit != null) {
        params.limit = limit;
      }
      if (offset != null) {
        params.offset = offset;
      }
      return (_ref = this.client).get.apply(_ref, ["/shops/" + this.shopId + "/listings/featured", token, secret].concat(__slice.call(params), [function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get featured listings error'));
        } else {
          return cb(null, body, headers);
        }
      }]));
    };

    Shop.prototype.activeListings = function() {
      var cb, limit, offset, params, secret, token, _arg, _i, _ref;
      params = 3 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 2) : (_i = 0, []), _arg = arguments[_i++], cb = arguments[_i++];
      token = _arg.token, secret = _arg.secret, limit = _arg.limit, offset = _arg.offset;
      params = params == null ? {} : params;
      if (limit != null) {
        params.push({
          limit: limit
        });
      }
      if (offset != null) {
        params.push({
          offset: offset
        });
      }
      return (_ref = this.client).get.apply(_ref, ["/shops/" + this.shopId + "/listings/active"].concat(__slice.call(params), [token], [secret], [function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get active listings error'));
        } else {
          return cb(null, body, headers);
        }
      }]));
    };

    Shop.prototype.draftListings = function() {
      var cb, limit, offset, params, secret, token, _arg, _i, _ref;
      params = 3 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 2) : (_i = 0, []), _arg = arguments[_i++], cb = arguments[_i++];
      token = _arg.token, secret = _arg.secret, limit = _arg.limit, offset = _arg.offset;
      params = params == null ? {} : params;
      if (limit != null) {
        params.push({
          limit: limit
        });
      }
      if (offset != null) {
        params.push({
          offset: offset
        });
      }
      return (_ref = this.client).get.apply(_ref, ["/shops/" + this.shopId + "/listings/draft"].concat(__slice.call(params), [token], [secret], [function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get draft listings error'));
        } else {
          return cb(null, body, headers);
        }
      }]));
    };

    Shop.prototype.expiredListings = function() {
      var cb, limit, offset, params, secret, token, _arg, _i, _ref;
      params = 3 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 2) : (_i = 0, []), _arg = arguments[_i++], cb = arguments[_i++];
      token = _arg.token, secret = _arg.secret, limit = _arg.limit, offset = _arg.offset;
      params = params == null ? {} : params;
      if (limit != null) {
        params.push({
          limit: limit
        });
      }
      if (offset != null) {
        params.push({
          offset: offset
        });
      }
      return (_ref = this.client).get.apply(_ref, ["/shops/" + this.shopId + "/listings/expired"].concat(__slice.call(params), [token], [secret], [function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get expired listings error'));
        } else {
          return cb(null, body, headers);
        }
      }]));
    };

    Shop.prototype.inactiveListings = function() {
      var cb, limit, offset, params, secret, token, _arg, _i, _ref;
      params = 3 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 2) : (_i = 0, []), _arg = arguments[_i++], cb = arguments[_i++];
      token = _arg.token, secret = _arg.secret, limit = _arg.limit, offset = _arg.offset;
      params = params == null ? {} : params;
      if (limit != null) {
        params.push({
          limit: limit
        });
      }
      if (offset != null) {
        params.push({
          offset: offset
        });
      }
      return (_ref = this.client).get.apply(_ref, ["/shops/" + this.shopId + "/listings/inactive"].concat(__slice.call(params), [token], [secret], [function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get inactive listings error'));
        } else {
          return cb(null, body, headers);
        }
      }]));
    };

    return Shop;

  })();

  module.exports = Shop;

}).call(this);
