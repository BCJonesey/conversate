Structural.Collections.Participants = Backbone.Collection.extend({
  model: Structural.Models.Participant,
  url: function() {
    return [Structural.apiPrefix, this.type + 's', this.id, 'participants'].join('/');
  },
  initialize: function(data, options) {
    options = options || {};
    this.id = options.id;
    this.type = options.type;
  },
  comparator: 'last_updated_time'
})
