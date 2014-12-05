#= require_self
#= require_tree .

Structural.Actions = {}

{buildMessage} = Structural.Data.Message

Structural.Actions.StartApp = new Hippodrome.Action(
  'Start App',
   -> {})

Structural.Actions.UpdateCurrentUser = new Hippodrome.Action(
  'Update Current User'
  (user) -> {user: user}
)
