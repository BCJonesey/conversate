Structural.Collections.Topics = Backbone.Collection.extend({
  model: Structural.Models.Topic,
  url: Structural.apiPrefix + '/topics',

  initialize: function(options) {
    options = options || {};
    this.startUpdate();
  },

  focus: function(id) {
    var topic = this.get(id);
    if(topic) {
      topic.focus();
    }

    this.filter(function(tpc) { return tpc.id != id; }).forEach(function(tpc) {
      tpc.unfocus();
    });
  },
  current: function() {
    return this.where({is_current: true}).pop();
  }
});

_.extend(Structural.Collections.Topics.prototype, Support.FetchTimer(30000));
