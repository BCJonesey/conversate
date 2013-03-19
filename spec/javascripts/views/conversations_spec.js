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
