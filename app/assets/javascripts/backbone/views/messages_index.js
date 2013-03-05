ConversateApp.Views.MessagesIndex = Backbone.View.extend({
  render: function () {
    var self = this;
    self.collection.each(function (message) {
      self.$el.append(JST['backbone/templates/messages/index']({ message: message,
                                                                  helpers: self.helpers }));
    });

    Enhancer.enhancify(self.$el);
    Scroller.scrollToBottom($('#thread'));

    return self;
  },
  initialize: function () {
        _.bindAll(this, 'render', 'add');

        this.collection.bind('add', this.add);
  },
  add: function (message) {
    var autoscroll = Scroller.atBottom($('#thread'));

    this.$el.append(JST['backbone/templates/messages/index']({ message: message,
                                                                helpers: this.helpers }))
    Enhancer.enhancify(this.$el);

    // For unknown reasons, this.$el's scrollTop is broken.
    if (autoscroll) {
      Scroller.scrollToBottom($('#thread'));
    }
  },
  helpers: {
    name: function (name) {
      return name.full_name || name.email;
    },
    names: function (names) {
      return _.map(names, function(name) {
        return name.full_name || name.email;
      }).join(', ');
    },
    ownMessageClass: function(message) {
      return (message.get('user').id == ConversateApp.current_user) ? ' my-message' : '';
    }
  }
});
