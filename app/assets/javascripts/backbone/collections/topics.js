Structural.Collections.Topics = Backbone.Collection.extend({
  model: Structural.Models.Topic,
  url: Structural.apiPrefix + '/topics'
});
