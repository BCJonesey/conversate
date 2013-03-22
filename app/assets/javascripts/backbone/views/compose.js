Structural.Views.Compose = Support.CompositeView.extend({
  className: 'act-compose',
  template: JST['backbone/templates/actions/compose'],
  initialize: function(options) {
    options = options || {};
    this.conversation = options.conversation;
  },
  render: function() {
    this.$el.html(this.template({conversation: this.conversation}));
    return this;
  },
  events: {
    submit: 'newMessageAction',
    'click a.enable-long-form': 'enableLongForm',
    'click a.disable-long-form': 'disableLongForm'
  },
  newMessageAction: function(e) {
    // TODO: Create new message.
  },
  enableLongForm: function(e) {
    // TODO: Open long form modal.
  },
  disableLongForm: function(e) {
    // TODO: Close long form modal.
  }
});
