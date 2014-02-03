Structural.Views.SearchResult = Support.CompositeView.extend({
  tagName: 'li',
  className: function() {
    var classes = 'search-result';

    if (this.model.get('result_type')) {
      classes += ' ' + this.model.get('result_type') + '-result';
    }

    return classes;
  },
  templates: {
    'action': JST.template('search/action_result'),
    'conversation': JST.template('search/conversation_result')
  },
  initialize: function(options) {

  },
  render: function() {
    this.$el.html(this.templates[this.model.get('result_type')]({
      result: this.model
    }));
  }
});
