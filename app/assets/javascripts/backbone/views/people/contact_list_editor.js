Structural.Views.ContactListEditor = Support.CompositeView.extend({
  className: 'contact-list-edit-box-wrap hidden',
  template: JST.template('people/contact_lists/contact_list_editor'),
  render:function(){
    this.$el.html(this.template());
  }
});
