ConversateApp.Views.MessagesIndex = Backbone.View.extend({
  render: function () {
    this.$el.html(JST['backbone/templates/messages/index']({ messages: this.collection,
                                                            helpers: this.helpers }));
    return this;
  },
  initialize: function () {
        _.bindAll(this, 'render', 'add');

        //this.collection.bind('all', this.render);
        this.collection.bind('add', this.add);
  },
  add: function (message) {
    console.log('adding');
    //$('#thread').append(message);
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
