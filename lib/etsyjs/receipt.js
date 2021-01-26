(function() {
  var Receipt, util,
    __slice = [].slice;

  util = require('util');

  Receipt = (function() {
    function Receipt(client) {
      this.client = client;
    }

    Receipt.prototype.findByShop = function() {
      var cb, limit, offset, params, secret, shopId, token, _arg, _i, _ref;
      shopId = arguments[0], params = 4 <= arguments.length ? __slice.call(arguments, 1, _i = arguments.length - 2) : (_i = 1, []), _arg = arguments[_i++], cb = arguments[_i++];
      token = _arg.token, secret = _arg.secret, limit = _arg.limit, offset = _arg.offset;
      params = params == null ? {} : params;
      if (limit != null) {
        params.limit = limit;
      }
      if (offset != null) {
        params.offset = offset;
      }
      if (typeof min_last_modified !== "undefined" && min_last_modified !== null) {
        params.min_last_modified = min_last_modified;
      }
      if (typeof max_last_modified !== "undefined" && max_last_modified !== null) {
        params.max_last_modified = max_last_modified;
      }
      return (_ref = this.client).get.apply(_ref, ["/shops/" + this.shopId + "/receipts", token, secret].concat(__slice.call(params), [function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get shop receipts error'));
        } else {
          return cb(null, body, headers);
        }
      }]));
    };

    Receipt.prototype.find = function(receiptId, cb) {
      return this.client.get("/receipts/" + this.receiptId, function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get receipt error'));
        } else {
          return cb(null, body, headers);
        }
      });
    };

    Receipt.prototype.updateUserProfile = function(user, cb) {
      return this.client.put("/users/" + this.userId + "/profile", user, function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Update user profile error'));
        } else {
          return cb(null, body, headers);
        }
      });
    };

    return Receipt;

  })();

  module.exports = Receipt;

}).call(this);
