describe("Structural", function() {
  describe("bar view", function() {
    it("has some buttons and a username", function() {
      var user = { name: "Dee Dee Ramone" };
      var model = new Structural.Models.User(user);
      var view = new Structural.Views.StructuralBar({model: model});
      view.render();

      console.log(view.$el.html());

      expect(view.$('.i-text').text()).toMatch(/Water Cooler/);
      expect(view.$('.i-text').text()).toMatch(/People/);
      expect(view.$('.i-text').text()).not.toMatch(/Admin/);
      expect(view.$('.i-text').text()).toMatch(/Dee Dee Ramone/);

      user = { name: "Monte A. Melnick",
               is_admin: true };
      model = new Structural.Models.User(user);
      view = new Structural.Views.StructuralBar({model: model});
      view.render();

      expect(view.$('.i-text').text()).toMatch(/Water Cooler/);
      expect(view.$('.i-text').text()).toMatch(/People/);
      expect(view.$('.i-text').text()).toMatch(/Admin/);
      expect(view.$('.i-text').text()).toMatch(/Monte A\. Melnick/);
    })
  });

  describe("app view", function() {
    it("has a watercooler and a bar", function() {
      var folders = [
        { name: "Conversations", id: 1 },
        { name: "Structural", id: 2 },
        { name: "Chatter", id: 3 }
      ];
      var conversations = [
        { title: "First",
          most_recent_message: 1,
          participants: [],
          id: 1
        },
        { title: "Third",
          most_recent_message: 3,
          participants: [],
          id: 2
        }
      ];
      var actions = [
        { type: "message",
          user: {
            name: "Ethan Allen",
            id: 2
          },
          timestamp: 1363802638003,
          id: 123,
          text: "This is a message"
        },
        { type: "retitle",
          user: {
            name: "Ethan Allen",
            id: 2
          },
          id: 878,
          timestamp: 1363802638003,
          title: "Conversation Title"
        },
        { type: "deletion",
          user: {
            name: "Ethan Allen",
            id: 2
          },
          id: 788,
          timestamp: 1363802638003,
          action_id: 123
        }
      ];
      var conversation = {
        name: "Conversation",
        id: 1
      };
      var participants = [
        { name: "Sharon Jones",
          id: 1
        },
        { name: "The Dap Kings",
          id: 2
        }
      ];
      var user = { full_name: "Jack Kennedy" };

      bootstrap = {
        folders: folders,
        conversations: conversations,
        actions: actions,
        participants: participants,
        conversation: conversation,
        user: user
      };

      // Jasmine appears to interfere with rendering to the body tag.
      Structural.setElement($('<div></div>'));

      Structural.start(bootstrap);

      expect(Structural.$('.water-cooler').length).toEqual(1);
      expect(Structural.$('.structural-bar').length).toEqual(1);
      expect(Structural.$('.tpc').length).toEqual(3);
      expect(Structural.$('.cnv').length).toEqual(2);
      expect(Structural.$('.act').length).toEqual(3);
    });
  });
});
