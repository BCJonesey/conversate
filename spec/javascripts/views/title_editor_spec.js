describe("Title editor", function() {
  var view, model;

  beforeEach(function() {
    model = new Structural.Models.Conversation({ title: "News on the March!" });
    view = new Structural.Views.TitleEditor({conversation: model});
    view.render();
  });

  it("starts out not in editing mode", function() {
    expect(view.$('.act-title-actions.hidden').length).toEqual(0);
    expect(view.$('.act-title-save-actions.hidden').length).toEqual(1);
    expect(view.$('input[readonly]').length).toEqual(1);
  });

  it("can be flipped to editing mode", function() {
    view.$('.act-title-edit').click();

    expect(view.$('.act-title-actions.hidden').length).toEqual(1);
    expect(view.$('.act-title-save-actions.hidden').length).toEqual(0);
    expect(view.$('input[readonly]').length).toEqual(0);
  });

  it("can be flipped out of editing mode", function() {
    view.$('.act-title-edit').click();
    // Can't use $('body') here because Jasmin co-opts it.
    Structural.$el.click();

    expect(view.$('.act-title-actions.hidden').length).toEqual(0);
    expect(view.$('.act-title-save-actions.hidden').length).toEqual(1);
    expect(view.$('input[readonly]').length).toEqual(1);
  });

  it("does not flip out of editing mode when clicking on itself", function() {
    view.$('.act-title-edit').click();
    view.$el.click();

    expect(view.$('.act-title-actions.hidden').length).toEqual(1);
    expect(view.$('.act-title-save-actions.hidden').length).toEqual(0);
    expect(view.$('input[readonly]').length).toEqual(0);
  })

  it("changes title on submit", function() {
    view.$('.act-title-edit').click();
    view.$('input').val('New Title!');
    view.$('form').submit();

    expect(view.$('.act-title-actions.hidden').length).toEqual(0);
    expect(view.$('.act-title-save-actions.hidden').length).toEqual(1);
    expect(view.$('input[readonly]').length).toEqual(1);

    expect(model.get('title')).toEqual('New Title!');
  });
})
