// A view for the topics toolbar and a container for the actual
// topics list.

Structural.Views.TopicContainer = Support.CompositeView.extend({
  className: 'tpc-container',
  initialize: function(options) {
    options = options || {};
    this.topics = options.topics;
  },
  render: function() {
    this.toolbarView = new Structural.Views.TopicToolbar();
    this.listView = new Structural.Views.Topics({collection: this.topics});
    this.inputView = new Structural.Views.NewTopic();

    this.appendChild(this.toolbarView);
    this.appendChild(this.listView);
    this.appendChild(this.inputView);

    this.toolbarView.on('new_topic', this.newTopic, this);
    this.inputView.on('create_topic', this.createTopic, this);
  },

  newTopic: function() {
    this.inputView.edit();
  },

  createTopic: function(name) {
    var model = new Structural.Models.Topic({name: name});
    this.topics.add(model);
    model.save();
  },

  moveConversationMode: function() {
    this.listView.moveConversationMode();
  }
});
