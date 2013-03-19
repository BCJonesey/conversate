Structural.Collections.Participants = Backbone.Collection.extend({
  model: Structural.Models.Participant,
  intialize: function(data, options) {
    options = options || {};
    if (options.conversation) {
      this.url = '/conversations/' + options.conversation + '/participants';
    }
  },
  comparator: 'last_updated_time'
})
