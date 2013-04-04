Structural.Collections.Topics = Backbone.Collection.extend({
  model: Structural.Models.Topic,
  url: Structural.apiPrefix + '/topics',

  focus: function(id) {
    this.findWhere({id: id}).focus();
  }
});
