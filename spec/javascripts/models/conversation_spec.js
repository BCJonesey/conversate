describe("Conversation model", function() {
  it("is unread if and only if messages were sent since it's been viewed", function() {
    var unreadAttributes = {
      most_recent_message: 100,
      most_recent_viewed: 10
    };
    var readAttributes = {
      most_recent_message: 10,
      most_recent_viewed: 100
    };

    expect((new Structural.Models.Conversation(unreadAttributes)).is_unread).toBeTruthy();
    expect((new Structural.Models.Conversation(readAttributes)).is_unread).toBeFalsy();
  });
});
