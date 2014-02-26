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
  },
  events: {
    'click': 'viewResult'
  },

  viewResult: function(e) {
    if (e) { e.preventDefault(); }

    if (this.model.get('result_type') === 'action') {
      var dummyConversation = new Structural.Models.Conversation({
        id: this.model.get('conversation_id'),
        title: this.model.get('conversation_title'),
        folder_ids: this.model.get('conversation_folders')
      });
      var dummyAction = new Structural.Models.Action({
        id: this.model.get('result_id')
      });

      Structural.viewAction(dummyConversation, dummyAction);
    } else if (this.model.get('result_type') === 'conversation') {
      // Coming in later story/pr
    }

    this.trigger('resultViewed');
  }
});
