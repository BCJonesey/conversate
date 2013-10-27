Support.CollectionFetcher = function(options) {
  return function(initialCollection) {
    var self = this;
    self._collection = initialCollection;
    self._waitingOnRequest = false;
    self._lastResponse = "";
    self._fetchesSinceChange = 0;

    if (typeof options.interval === "number") {
      self._intervals = [options.interval];
    } else {
      var min = options.interval.min, max = options.interval.max;
      var steps = _.times(10, function(index) {
        var interpolated = (max - min) * ((index + 1) / 10);
        return min + interpolated;
      });
      self._intervals = [min, min, min].concat(steps);
    }

    self._nextTimeoutLength = function() {
      var index = Math.min(self._intervals.length - 1, Math.max(0, self._fetchesSinceChange));
      return self._intervals[index];
    }

    self._requestFinished = function(collection, response, opts) {
      if (self._lastResponse === opts.xhr.responseText) {
        self._fetchesSinceChange += 1;
      } else {
        self._fetchesSinceChange = 0;
      }

      self._lastResponse = opts.xhr.responseText;
      self._waitingOnRequest = false;
      setTimeout(self._fetchHandler, self._nextTimeoutLength());
    };

    self._fetchHandler = function() {
      if (!self._waitingOnRequest) {
        if (Support.DebugMode.noFetching) {
          setTimeout(self._fetchHandler, self._nextTimeoutLength());
          return;
        }

        self._collection.fetch({
          remove: false,
          cache: false,
          success: self._requestFinished,
          error: self._requestFinished
        });
        self._waitingOnRequest = true;
      }
    };
    setTimeout(self._fetchHandler, self._nextTimeoutLength());

    if (options.event) {
      Structural.on(options.event, function(eventArg) {
        self._collection = options.collFunc(eventArg);
      });
    }
  };
};
