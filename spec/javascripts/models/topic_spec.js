describe("Topic model", function() {
  it("can be unread", function() {
    var read = new Structural.Models.Topic({unread_conversations: 0});
    var unread = new Structural.Models.Topic({unread_conversations: 12});

    expect(read.is_unread).toBeFalsy();
    expect(unread.is_unread).toBeTruthy();
  });

  it("can be the current conversation", function() {
    Structural.Router.currentTopicId = 10;
    var topic = new Structural.Models.Topic({id: 10});
    expect(topic.is_current).toBeTruthy();

    var topic = new Structural.Models.Topic({id: 12});
    expect(topic.is_current).toBeFalsy();
  })
});
