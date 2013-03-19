Structural.Views.TopicContainer = Support.CompositeView.extend({
  className: 'tpc-container',
  initialize: function(options) {
    options = options || {};
    this.topics = options.topics;
  },
  render: function() {
    var toolbar = new Structural.Views.TopicToolbar();
    var list = new Structural.Views.Topics({collection: this.topics});
    var input = new Structural.Views.NewTopic();

    this.appendChild(toolbar);
    this.appendChild(list);
    this.appendChild(input);
  }
});
