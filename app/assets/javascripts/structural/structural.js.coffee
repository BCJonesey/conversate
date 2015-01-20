#= require_self
#= require ./urls/urls
#= require ./http/http
#= require ./api/api
#= require ./data/data
#= require ./actions/actions
#= require ./stores/stores
#= require ./deferred_tasks/deferred_tasks
#= require ./components/components
#
#= require_tree .

# We need exactly one top-level object so that tests and whatever
# can get access to our stuff.  Any other assignment to window. is
# probably an error.
window.Structural = {}

Structural.startApp = ->
  Hippodrome.start()
  React.render(Structural.Components.App(), document.body)
