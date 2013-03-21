describe("Action view", function() {
  var messageView, updateUsersView, retitleView, deletionView;

  beforeEach(function() {
    var messageAction = {
      type: "message",
      user: 2,
      timestamp: 1363802638003,
      id: 123,
      text: "This is a message"
    };
    var updateUserAction = {
      type: "update_users",
      user: 2,
      timestamp: 1363802638003,
      id: 456,
      added: [1, 3],
      removed: [4]
    };
    var retitleAction = {
      type: "retitle",
      user: 2,
      id: 878,
      timestamp: 1363802638003,
      title: "Conversation Title"
    };
    var deletionAction = {
      type: "deletion",
      user: 2,
      id: 788,
      timestamp: 1363802638003,
      action_id: 123
    };

    var messageModel = new Structural.Models.Action(messageAction);
    var updateUserModel = new Structural.Models.Action(updateUserAction);
    var retitleModel = new Structural.Models.Action(retitleAction);
    var deletionModel = new Structural.Models.Action(deletionAction);

    messageView = new Structural.Views.Action({model: messageModel});
    updateUsersView = new Structural.Views.Action({model: updateUserModel});
    retitleView = new Structural.Views.Action({model: retitleModel});
    deletionView = new Structural.Views.Action({model: deletionModel});
    messageView.render();
    updateUsersView.render();
    retitleView.render();
    deletionView.render();
  });

  it("has the right class for its type", function() {
    expect(messageView.$el.hasClass('act-message')).toBeTruthy();
    expect(messageView.$el.hasClass('act-update-users')).toBeFalsy();
    expect(messageView.$el.hasClass('act-retitle')).toBeFalsy();
    expect(messageView.$el.hasClass('act-deletion')).toBeFalsy();

    expect(updateUsersView.$el.hasClass('act-message')).toBeFalsy();
    expect(updateUsersView.$el.hasClass('act-update-users')).toBeTruthy();
    expect(updateUsersView.$el.hasClass('act-retitle')).toBeFalsy();
    expect(updateUsersView.$el.hasClass('act-deletion')).toBeFalsy();

    expect(retitleView.$el.hasClass('act-message')).toBeFalsy();
    expect(retitleView.$el.hasClass('act-update-users')).toBeFalsy();
    expect(retitleView.$el.hasClass('act-retitle')).toBeTruthy();
    expect(retitleView.$el.hasClass('act-deletion')).toBeFalsy();

    expect(deletionView.$el.hasClass('act-message')).toBeFalsy();
    expect(deletionView.$el.hasClass('act-update-users')).toBeFalsy();
    expect(deletionView.$el.hasClass('act-retitle')).toBeFalsy();
    expect(deletionView.$el.hasClass('act-deletion')).toBeTruthy();
  });

  it("has the right content for its type", function() {
    expect(messageView.$('.act-text').length).toEqual(1);
    expect(retitleView.$el.text()).toMatch(/titled the conversation "Conversation Title"/);
    // TODO: Fill this in once the user thing is sorted out.
    expect(updateUsersView.$el.text()).toMatch(/.*/);
    expect(deletionView.$el.text()).toMatch(/deleted a message/);
  });
});
