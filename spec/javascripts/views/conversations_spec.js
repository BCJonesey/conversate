describe("Conversation view", function() {
  var conversation, view;

  beforeEach(function() {
    conversation = {
      "id": 3,
      "title": "Talk about stuff",
      "most_recent_message": 1734512345,
      "most_recent_viewed": 1722345134,
      "participants": [
        { "id": 2,
          "name": "Paul Revere",
          "last_updated_time": 1635123423,
        },
        { "id": 4,
          "name": "Thomas Paine",
          "last_updated_time": 1213423423,
        }
      ]
    };
    view = new Structural.Views.Conversation({model: new Structural.Models.Conversation(conversation)});
    view.render();
  });

  it("has the conversation title", function() {
    expect(view.$('.cnv-title').text()).toEqual('Talk about stuff');
  });

  it("is unread", function() {
    expect(view.className).toMatch(/cnv-unread/);
  });

  it("has the participants in order", function() {
    expect(view.$('.cnv-participant')[0].innerText).toEqual('Thomas Paine');
    expect(view.$('.cnv-participant')[1].innerText).toEqual('Paul Revere');
  });
});

describe("Conversation list view", function() {
  var conversations, view;

  beforeEach(function() {
    conversations = [
      { title: "First",
        most_recent_message: 1,
        participants: []
      },
      { title: "Third",
        most_recent_message: 3,
        participants: []
      },
      { title: "Fourth",
        most_recent_message: 4,
        participants: []
      },
      { title: "Second",
        most_recent_message: 2,
        participants: []
      }
    ];
    var collection = new Structural.Collections.Conversations(conversations);
    view = new Structural.Views.Conversations({collection: collection});
    view.render();
  });

  it("has a tag for each conversation", function() {
    expect(view.$('.cnv').length).toEqual(4);
  });

  it("has the conversations in order", function() {
    expect(view.$('.cnv .cnv-title')[0].innerText).toEqual('First');
    expect(view.$('.cnv .cnv-title')[1].innerText).toEqual('Second');
    expect(view.$('.cnv .cnv-title')[2].innerText).toEqual('Third');
    expect(view.$('.cnv .cnv-title')[3].innerText).toEqual('Fourth');
  });
});
