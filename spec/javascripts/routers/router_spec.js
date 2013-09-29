describe("Structural router", function() {
  var bootstrap;
  beforeEach(function() {
    var folders = [
      { name: "Conversations", id: 1 },
      { name: "Structural", id: 2 },
      { name: "Chatter", id: 3 }
    ];
    var conversations = [
      { title: "First",
        most_recent_message: 1,
        participants: []
      },
      { title: "Third",
        most_recent_message: 3,
        participants: []
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
      id: 1,
      folder_id: 2
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
    // So that the router can access it.
    window.bootstrap = bootstrap;
  });

  // We don't want to start the history here, because we get errors if we
  // try to start the history twice (and there's no way to stop if).  We'll
  // have to settle for calling the router methods directly instead of
  // testing what happens when you hit a particular url.  C'est la vie.

  describe("calls focus appropriately", function() {
    beforeEach(function() {
      spyOn(Structural, 'focus');
    });

    it("from the index page", function() {
      Structural.Router.index();
      expect(Structural.focus).toHaveBeenCalledWith({folder: 1});
    });

    it("from the conversation page", function() {
      Structural.Router.conversation('the-awesome-conversation', 1);
      expect(Structural.focus).toHaveBeenCalledWith({folder: 2,
                                                     conversation: 1});
    });

    it("from the message page", function() {
      Structural.Router.message('the-awesome-conversation', 1, 543);
      expect(Structural.focus).toHaveBeenCalledWith({folder: 2,
                                                     conversation: 1,
                                                     message: 543});
    });

    it("from the folder page", function() {
      Structural.Router.folder('look-a-folder', 3);
      expect(Structural.focus).toHaveBeenCalledWith({folder: 3});
    })
  });
});
