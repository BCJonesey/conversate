describe("Folder model", function() {
  it("can be unread", function() {
    var read = new Structural.Models.Folder({unread_conversations: 0});
    var unread = new Structural.Models.Folder({unread_conversations: 12});

    expect(read.get('is_unread')).toBeFalsy();
    expect(unread.get('is_unread')).toBeTruthy();
  });

  it("can be the current conversation", function() {;
    var folder = new Structural.Models.Folder({id: 10});
    expect(folder.get('is_current')).toBeFalsy();

    folder.focus();
    expect(folder.get('is_current')).toBeTruthy();
  })
});
