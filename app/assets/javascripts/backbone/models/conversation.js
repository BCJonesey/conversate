Structural.Models.Conversation = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (this.attributes.participants) {
      this.attributes.participants = new Structural.Collections.Participants(this.attributes.participants);
    }
  }
});
