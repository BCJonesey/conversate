Structural.Views.Actions = Support.CompositeView.extend({
  className: 'act-list',
  initialize: function(options) {
  },
  render: function() {
    this.collection.forEach(this.renderAction, this);
    return this;
  },
  renderAction: function(action) {
    var view = new Structural.Views.Action({model: action});
    this.appendChild(view);
  }
});
