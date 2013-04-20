Structural.Models.User = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (!this.get('name')) {
      this.set('name', this.get('full_name') || this.get('email'));
    }

    if (this.get('address_book')) {
      this.set('address_book', new Structural.Collections.Participants(this.get('address_book')));
    }
  }
});
