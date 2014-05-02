
{Emitter} = require 'emissary'
dotty = require 'dotty'

class Store
  Emitter.includeInto @

  constructor: (options = {}) ->
    @_data = {}
    @_default = {}


  setDefaults: ->


  ##
  # Modifier
  ##
  get: (key) ->
    dotty.get @_data, key

  set: (key, value) ->
    edited = dotty.put @_data, key, value
    if edited
      @emit "updated.#{key}"
      @update()
    return edited

  del: (key) ->
    removed = dotty.remove @_data, key
    if removed
      @emit "updated.#{key}"
      @update()
    return remove

  toggle: (key) ->
    @set key, !@get(key)


  ##
  # Observer
  ##
  observe: -> # todo
  unobserve: -> # todo


  ##
  # Saver
  ##
  update: ->
    @save()
    @emit 'updated'

  save: ->

module.exports = Store
