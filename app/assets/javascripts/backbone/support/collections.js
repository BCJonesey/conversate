Support.Collections = {
  // This should be identical to _.difference, but I can't get that to work
  // for me.  It keeps giving me garbage or not existing, depending on how
  // I call it.
  difference: function(a, b) {
    return a.reject(function(x) {
      return b.contains(x);
    });
  }
};
