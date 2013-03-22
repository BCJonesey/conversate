describe("Action", function() {
  var messageAction, updateUserAction, retitleAction, deletionAction;
  var messageView, updateUsersView, retitleView, deletionView;

  beforeEach(function() {
    messageAction = {
      type: "message",
      user: {
        name: "Ethan Allen",
        id: 2
      },
      timestamp: 1363802638003,
      id: 123,
      text: "This is a message"
    };
    updateUserAction = {
      type: "update_users",
      user: {
        name: "Ethan Allen",
        id: 2
      },
      timestamp: 1363802638003,
      id: 456,
      added: [
        { name: "George Washington",
          id: 1
        },
        { name: "Benjamin Franklin",
          id: 5
        }
      ],
      removed: [
        { name: "John Adams",
          id: 4
        }
      ]
    };
    retitleAction = {
      type: "retitle",
      user: {
        name: "Ethan Allen",
        id: 2
      },
      id: 878,
      timestamp: 1363802638003,
      title: "Conversation Title"
    };
    deletionAction = {
      type: "deletion",
      user: {
        name: "Ethan Allen",
        id: 2
      },
      id: 788,
      timestamp: 1363802638003,
      action_id: 123
    };
  });

  describe("view", function() {
    beforeEach(function() {
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
      expect(retitleView.$el.text()).toMatch(/Ethan Allen titled the conversation "Conversation Title"/);
      expect(updateUsersView.$el.text()).toMatch(/added\s*George Washington/);
      expect(updateUsersView.$el.text()).toMatch(/removed\s*John Adams/);
      expect(deletionView.$el.text()).toMatch(/deleted a message/);
    });
  });

  describe("list view", function() {
    it("has each of the items in it", function() {
      var actions = [messageAction, updateUserAction, retitleAction, deletionAction];
      var collection = new Structural.Collections.Actions(actions);
      var view = new Structural.Views.Actions({collection: collection});
      view.render();

      expect(view.$('.act')[0].innerText).toMatch(/This is a message/);
      expect(view.$('.act')[1].innerText).toMatch(/George Washington/);
      expect(view.$('.act')[2].innerText).toMatch(/titled the conversation/);
      expect(view.$('.act')[3].innerText).toMatch(/deleted a message/);
    });
  });

  describe("compose view", function() {
    var view;

    beforeEach(function() {
      var conversation = new Structural.Models.Conversation({ title: "My Conversation" });
      view = new Structural.Views.Compose({conversation: conversation});
      view.render();
    })

    it("has two text areas", function() {
      expect(view.$('.short-form-compose textarea').length).toEqual(1);
      expect(view.$('.long-form-compose textarea').length).toEqual(1);
    });

    it("shows the title in the long form", function() {
      expect(view.$('.long-form-compose .title-text').text()).toMatch(/My Conversation/);
    });
  });
});
