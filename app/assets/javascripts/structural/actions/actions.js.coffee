#= require_self
#= require_tree .

Structural.Actions = {}

Structural.Actions.UpdateCurrentUser = Hippodrome.createAction
  displayName: 'Update Current User'
  build: (user) -> {user: user}
