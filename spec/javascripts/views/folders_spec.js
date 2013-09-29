describe("Folder list view", function() {
  var folders, collection, view;

  beforeEach(function() {
    folders = [
      { name: "Conversations", id: 1 },
      { name: "Structural", id: 2 },
      { name: "Chatter", id: 3 }
    ];
    collection = new Structural.Collections.Folders(folders);
    view = new Structural.Views.Folders({collection: collection});
    view.render();
  });

  it("has an entry for each folder", function() {
    expect(view.$('.fld').length).toEqual(3);
  });

  it("has each folder's name", function() {
    expect(view.$('.fld')[0].innerText.trim()).toEqual(folders[0].name);
    expect(view.$('.fld')[1].innerText.trim()).toEqual(folders[1].name);
    expect(view.$('.fld')[2].innerText.trim()).toEqual(folders[2].name);
  });

  it("has a top-level class", function() {
    expect(view.el.className).toEqual("fld-list");
  });

  it("has a folder hint tag", function() {
    expect(view.$('.fld-hint').length).toEqual(1);
  });

  it("can be focused", function() {
    expect(view.$('.fld-current').length).toEqual(0);

    collection.focus(1);
    expect(view.$('.fld-current').length).toEqual(1);
    expect(view.$('.fld-current').text()).toMatch(/Conversations/);

    collection.focus(2);
    expect(view.$('.fld-current').length).toEqual(1);
    expect(view.$('.fld-current').text()).toMatch(/Structural/);
  });
});

describe("Folder toolbar view", function() {
  var view;

  beforeEach(function() {
    view = new Structural.Views.FolderToolbar();
    view.render();
  });

  it("has a new folder button", function() {
    expect(view.$('.fld-new-button').length).toEqual(1);
  });
});

describe("New folder input view", function() {
  var view;

  beforeEach(function() {
    view = new Structural.Views.NewFolder();
    view.render();
  });

  it("has an input for the new folder name", function() {
    expect(view.$('input[name="name"].fld-new-input').length).toEqual(1);
  });
});

describe("Folder container view", function() {
  var folders, collection, view;

  beforeEach(function() {
    folders = [
      { name: "Conversations", id: 1 },
      { name: "Structural", id: 2 },
      { name: "Chatter", id: 3 }
    ];
    collection = new Structural.Collections.Folders(folders);
    view = new Structural.Views.FolderContainer({folders: collection});
    view.render();
  });

  it("has each of its sub-views", function() {
    expect(view.$('.fld-toolbar').length).toEqual(1);
    expect(view.$('.fld-list .fld').length).toEqual(3);
    expect(view.$('.fld-new-input').length).toEqual(1);
  })
});
