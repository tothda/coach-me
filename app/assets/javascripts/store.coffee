App.Store = DS.Store.extend
  revision: 11
  adapter: DS.RESTAdapter.extend()

DS.JSONTransforms.date =
  deserialize: (serialized) ->
    Date.parse(serialized)
    
  serialize: (deserialized) ->
    deserialized.toString()
