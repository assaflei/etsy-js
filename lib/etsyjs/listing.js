(function() {
  var Listing,
    __slice = [].slice;

  Listing = (function() {
    function Listing(listingId, client) {
      this.listingId = listingId;
      this.client = client;
    }

    Listing.prototype.find = function() {
      var cb, params, _i, _ref;
      params = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), cb = arguments[_i++];
      return (_ref = this.client).get.apply(_ref, ["/listings/" + this.listingId].concat(__slice.call(params), [function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get listings error'));
        } else {
          return cb(null, body, headers);
        }
      }]));
    };

    Listing.prototype.active = function() {
      var cb, params, _i, _ref;
      params = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), cb = arguments[_i++];
      return (_ref = this.client).get.apply(_ref, ["/listings/active"].concat(__slice.call(params), [function(err, status, body, headers) {
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

    Listing.prototype.trending = function() {
      var cb, params, _i, _ref;
      params = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), cb = arguments[_i++];
      return (_ref = this.client).get.apply(_ref, ["/listings/trending"].concat(__slice.call(params), [function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get trending listings error'));
        } else {
          return cb(null, body, headers);
        }
      }]));
    };

    Listing.prototype.interesting = function() {
      var cb, params, _i, _ref;
      params = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), cb = arguments[_i++];
      return (_ref = this.client).get.apply(_ref, ["/listings/interesting"].concat(__slice.call(params), [function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Get interesting listings error'));
        } else {
          return cb(null, body, headers);
        }
      }]));
    };

    Listing.prototype.create = function(shop, listing, cb) {
      return this.client.post("/shops/" + shop + "/listings", listing, null, function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 201) {
          return cb(new Error('Create a new listing error'));
        } else {
          return cb(null, body, headers);
        }
      });
    };

    Listing.prototype.update = function(listing, cb) {
      return this.client.put("/listings/" + this.listingId, listing, function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Update listing error'));
        } else {
          return cb(null, body, headers);
        }
      });
    };

    Listing.prototype.updateInventory = function(listing, cb) {
      return this.client.put("/listings/" + this.listingId + "/inventory", JSON.stringify(listing), "application/json", function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Update listing quantity error'));
        } else {
          return cb(null, body, headers);
        }
      });
    };

    Listing.prototype.updateVariationImages = function(varImagesData, cb) {
      return this.client.post("/listings/" + this.listingId + "/variation-images", varImagesData, function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 200) {
          return cb(new Error('Update listing variation images error'));
        } else {
          return cb(null, body, headers);
        }
      });
    };

    Listing.prototype.uploadListingImage = function() {
      var cb, imageData, params, shop, _i, _ref;
      shop = arguments[0], imageData = arguments[1], params = 4 <= arguments.length ? __slice.call(arguments, 2, _i = arguments.length - 1) : (_i = 2, []), cb = arguments[_i++];
      return (_ref = this.client).postMultipart.apply(_ref, ["/shops/" + shop + "/listings/" + this.listingId + "/images", imageData].concat(__slice.call(params), [function(err, status, body, headers) {
        if (err) {
          return cb(err);
        }
        if (status !== 201) {
          return cb(new Error('Update listing images error'));
        } else {
          return cb(null, body, headers);
        }
      }]));
    };

    return Listing;

  })();

  module.exports = Listing;

}).call(this);
