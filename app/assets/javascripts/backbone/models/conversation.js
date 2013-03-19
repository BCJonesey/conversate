Structural.Models.Conversation = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (this.attributes.participants) {
      this.attributes.participants = new Structural.Collections.Participants(this.attributes.participants);
    }

    this.is_unread = this.attributes.most_recent_message > this.attributes.most_recent_viewed;

    // TODO: Figure out where the current conversation comes from (options?), set
    // this.is_current variable.
    this.is_current = false;
  }
});
