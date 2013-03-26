describe("Water Cooler view", function() {
  var view;

  beforeEach(function() {
    var topics = [
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

    var topicsCollection = new Structural.Collections.Topics(topics);
    var conversationsCollection = new Structural.Collections.Conversations(conversations);
    var actionsCollection = new Structural.Collections.Actions(actions);
    var conversationModel = new Structural.Models.Conversation(conversation);
    var participantsCollection = new Structural.Collections.Participants(participants);

    view = new Structural.Views.WaterCooler({
      topics: topicsCollection,
      conversations: conversationsCollection,
      actions: actionsCollection,
      conversation: conversationModel,
      participants: participantsCollection
    })
    view.render();
  });

  it("has a topics column", function() {
    expect(view.$('.tpc-container').length).toEqual(1);
    expect(view.$('.tpc').length).toEqual(3);
  });

  it("has a conversations column", function() {
    expect(view.$('.cnv-container').length).toEqual(1);
    expect(view.$('.cnv').length).toEqual(2);
  });

  it("has an actions column", function() {
    expect(view.$('.act-container').length).toEqual(1);
    expect(view.$('.act').length).toEqual(3);
  });
});
