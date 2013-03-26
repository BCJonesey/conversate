Structural.Views.ParticipantOptions = Support.CompositeView.extend({
  tagName: 'ul',
  className: 'token-options',
  initialize: function(options) {

  },
  render: function() {
    this.collection.each(this.renderOption, this);
    return this;
  },
  renderOption: function(option) {
    var view = new Structural.Views.ParticipantOption({model: option});
    this.appendChild(view);
  }
});
