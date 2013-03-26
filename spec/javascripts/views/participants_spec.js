describe("Participants", function() {
  var participants;

  beforeEach(function() {
    participants = [
      { name: "Sharon Jones",
        id: 1
      },
      { name: "The Dap Kings",
        id: 2
      }
    ]
  });

  describe("token view", function() {
    it("has a name and a close button", function() {
      var model = new Structural.Models.Participant(participants[0]);
      var view = new Structural.Views.Participant({model: model});
      view.render();

      expect(view.$el.text()).toMatch(/Sharon Jones/);
      expect(view.$('.participant-remove').length).toEqual(1);
    })
  });

  describe("token list view", function() {
    var view;

    beforeEach(function() {
      var collection = new Structural.Collections.Participants(participants);
      view = new Structural.Views.Participants({collection: collection});
      view.render();
    })

    it("has each participant's token", function() {
      expect(view.$('.token').length).toEqual(2);
    });

    it("has an input at the end", function() {
      expect(view.$('li:last').hasClass('token-input-wrap')).toBeTruthy();
    });

    it("has a user reminder at the start", function() {
      expect(view.$('li:first').hasClass('user-reminder')).toBeTruthy();
    });
  });

  describe("option view", function() {
    it("has a name", function() {
      var model = new Structural.Models.Participant(participants[0]);
      var view = new Structural.Views.ParticipantOption({model: model});
      view.render();

      expect(view.$el.text()).toMatch(/Sharon Jones/);
    });
  });

  describe("option list view", function() {
    it("has an entry for each option", function() {
      var collection = new Structural.Collections.Participants(participants);
      var view = new Structural.Views.ParticipantOptions({collection: collection});
      view.render();

      expect(view.$('.token-option').length).toEqual(2);
    });
  });
});
