Structural.Views.Compose = Support.CompositeView.extend({
  className: 'act-compose',
  template: JST['backbone/templates/actions/compose'],
  initialize: function(options) {
    options = options || {};
    this.conversation = options.conversation;
  },
  render: function() {
    this.$el.html(this.template({conversation: this.conversation}));

    this._short = this.$('.short-form-compose');
    this._long = this.$('.long-form-compose');

    return this;
  },
  events: {
    submit: 'newMessageAction',
    'click a.enable-long-form': 'enableLongForm',
    'click a.disable-long-form': 'disableLongForm',
    'keydown .short-form-compose textarea': 'shortFormType'
  },
  newMessageAction: function(e) {
    var input = this._long.hasClass('hidden') ? this._short : this._long;
    Structural.createMessageAction(input.find('textarea').val());
    input.find('textarea').val('');
  },
  enableLongForm: function(e) {
    this._long.find('textarea').val(this._short.find('textarea').val());
    this._long.removeClass('hidden');
  },
  disableLongForm: function(e) {
    this._short.find('textarea').val(this._long.find('textarea').val());
    this._long.addClass('hidden');
  },
  shortFormType: function(e) {
    if (e.which == 13) { // Enter
      e.preventDefault();
      this.newMessageAction();
    }
  }
});
