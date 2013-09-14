Structural.Views.Compose = Support.CompositeView.extend({
  className: 'act-compose',
  template: JST['backbone/templates/actions/compose'],
  initialize: function(options) {
    options = options || {};
    this.conversation = options.conversation;

    Structural.on('changeConversation', this.changeConversation, this);
  },
  render: function() {
    this.$el.html(this.template({conversation: this.conversation}));

    this._short = this.$('.short-form-compose');
    this._long = this.$('.long-form-compose');

    return this;
  },
  events: {
    'click .act-short-form-send': 'newMessageAction',
    'click .send-long-form': 'newMessageAction',
    'click a.enable-long-form': 'enableLongForm',
    'click a.disable-long-form': 'disableLongForm',
    'keydown .short-form-compose textarea': 'shortFormType',
    'focus .short-form-compose': 'shortFormFocus'
  },
  newMessageAction: function(e) {
    if (e) { e.preventDefault(); }
    var input = this._long.hasClass('hidden') ? this._short : this._long;
    Structural.createMessageAction(input.find('textarea').val());
    input.find('textarea').val('');
    this.disableLongForm();

    // The user has actually taken an action which we consider to be a viewing update.
    this.conversation.updateMostRecentViewedToNow();
  },
  enableLongForm: function(e) {
    if (e) { e.preventDefault(); }
    this._long.find('textarea').val(this._short.find('textarea').val());
    this._long.removeClass('hidden');

    // This action is considered to signify having read a conversation.
    Structural.trigger('readConversation', Structural._conversation);
  },
  disableLongForm: function(e) {
    if (e) { e.preventDefault(); }
    this._short.find('textarea').val(this._long.find('textarea').val());
    this._long.addClass('hidden');
  },
  shortFormType: function(e) {
    if (e.which === Support.Keys.enter) {
      this.newMessageAction(e);
    }
  },
  shortFormFocus: function(e) {

    // This action is considered to signify having read a conversation.
    Structural.trigger('readConversation', Structural._conversation);
  },
  changeConversation: function(conversation) {
    this.conversation = conversation;
    this.$el.empty();
    this.render();
  }
});
