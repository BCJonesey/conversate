Structural.Models.ContactList = Backbone.Model.extend({
  urlRoot: function() {return Structural.apiPrefix + "/contact_lists"},
  initialize: function(attributes, options) {
    var self = this;
    this.inflateExtend(this.attributes);
  },
  parse: function (response, options) {
    return this.inflateReturn(response);
  },
  inflateAttributes: function(attrs) {
    if (attrs.contacts) {
      attrs.contacts = this.inflate(Structural.Collections.Contacts,
       attrs.contacts);
    }
    return attrs;
  }
});

_.extend(Structural.Models.ContactList.prototype, Support.InflatableModel);
