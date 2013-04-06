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
  var conversations, collection, view;

  beforeEach(function() {
    conversations = [
      { title: "First",
        most_recent_message: 1,
        participants: [],
        id: 53
      },
      { title: "Third",
        most_recent_message: 3,
        participants: [],
        id: 19
      },
      { title: "Fourth",
        most_recent_message: 4,
        participants: [],
        id: 99
      },
      { title: "Second",
        most_recent_message: 2,
        participants: [],
        id: 3
      }
    ];
    collection = new Structural.Collections.Conversations(conversations);
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

  it("can be focused", function() {
    expect(view.$('.cnv-current').length).toEqual(0);

    collection.focus(53);
    expect(view.$('.cnv-current').length).toEqual(1);
    expect(view.$('.cnv-current').text()).toMatch(/First/);

    collection.focus(19);
    expect(view.$('.cnv-current').length).toEqual(1);
    expect(view.$('.cnv-current').text()).toMatch(/Third/);
  })
});

describe("Conversation toolbar view", function() {
  var view;

  beforeEach(function() {
    view = new Structural.Views.ConversationToolbar();
    view.render();
  });

  it("has a new conversation button", function() {
    expect(view.$('.cnv-new-button').length).toEqual(1);
  });
});

describe("Conversation container view", function() {
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
    view = new Structural.Views.ConversationContainer({conversations: collection});
    view.render();
  });

  it("has all the conversations", function() {
    expect(view.$el.text()).toMatch(/First/);
    expect(view.$el.text()).toMatch(/Second/);
    expect(view.$el.text()).toMatch(/Third/);
    expect(view.$el.text()).toMatch(/Fourth/);
  });

  it("has a toolbar", function() {
    expect(view.$('.cnv-toolbar').length).toEqual(1);
  });

  it("has a list", function() {
    expect(view.$('.cnv-list').length).toEqual(1);
  });
});
