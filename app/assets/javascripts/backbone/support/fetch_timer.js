Support.FetchTimer = function(interval) {
  return {
    startUpdate: function() {
      // Passing this.update.call as the function argument to setInterval doesn't
      // seem to work, and I'm not sure why.
      var self = this;
      this.fetchHandler = setInterval(function() {
        self.update();
      }, interval);
    },
    stopUpdate: function() {
      clearInterval(fetchHandler);
    },
    update: function() {
      //this.fetch({cache: false});
    }
  };
}
