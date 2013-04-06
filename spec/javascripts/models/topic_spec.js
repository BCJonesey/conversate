describe("Topic model", function() {
  it("can be unread", function() {
    var read = new Structural.Models.Topic({unread_conversations: 0});
    var unread = new Structural.Models.Topic({unread_conversations: 12});

    expect(read.get('is_unread')).toBeFalsy();
    expect(unread.get('is_unread')).toBeTruthy();
  });

  it("can be the current conversation", function() {;
    var topic = new Structural.Models.Topic({id: 10});
    expect(topic.get('is_current')).toBeFalsy();

    topic.focus();
    expect(topic.get('is_current')).toBeTruthy();
  })
});
