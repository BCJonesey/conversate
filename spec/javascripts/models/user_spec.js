describe("User model", function() {
  it("can compute user's names", function() {
    var model = new Structural.Models.User({name: "James"});
    expect(model.get('name')).toEqual('James');

    model = new Structural.Models.User({name: "James", full_name: "Steve", email: "Greg"});
    expect(model.get('name')).toEqual('James');

    model = new Structural.Models.User({full_name: "Steve"});
    expect(model.get('name')).toEqual('Steve');

    model = new Structural.Models.User({full_name: "Steve", email: "Greg"});
    expect(model.get('name')).toEqual('Steve');

    model = new Structural.Models.User({email: "Greg"});
    expect(model.get('name')).toEqual('Greg');
  })
});
