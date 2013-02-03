ConversateApp.Views.MessagesIndex = Backbone.View.extend({
  render: function () {
    var self = this;
    self.collection.each(function (message) {
      console.log(self.helpers);
      self.$el.append(JST['backbone/templates/messages/index']({ message: message, helpers: self.helpers }))
    });
    return self;
  },
  initialize: function () {
        _.bindAll(this, 'render', 'add');

        this.collection.bind('add', this.add);
  },
  add: function (message) {
    this.$el.append(JST['backbone/templates/messages/index']({ message: message, helpers: this.helpers }))
  },
  helpers: {
    name: function (name) {
      return name.full_name || name.email;
    },
    names: function (names) {
      return _.map(names, function(name) {
        return name.full_name || name.email;
      }).join(', ');
    }
  }
});
