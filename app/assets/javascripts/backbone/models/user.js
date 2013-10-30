Structural.Models.User = Backbone.Model.extend({
  initialize: function(attributes, options) {
    if (!this.get('name')) {
      if (this.get('full_name') && this.get('full_name').length > 0) {
        this.set('name', this.get('full_name'));
      } else {
        this.set('name', this.get('email'));
      }
    }

    this.inflateExtend(this.attributes);
  },

  inflateAttributes: function(attrs) {
    if (attrs.address_book) {
      attrs.address_book = this.inflate(Structural.Collections.Participants,
                                        attrs.address_book);
    }
    return attrs;
  }
});

_.extend(Structural.Models.User.prototype, Support.InflatableModel);
