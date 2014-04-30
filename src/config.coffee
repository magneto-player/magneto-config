
{Emitter} = require 'emissary'
fs = require 'fs-plus'
path = require 'path'
_ = require 'lodash'
assert = require 'assert'
dotty = require 'dotty'
cc = require 'config-chain'

class Config
  Emitter.includeInto @

  constructor: (options = {}) ->
    @_settings = {}
    @_default = {}

    assert.ok(options.dir, 'options.dir is mandatory.')
    @_configFilePath = path.join options.dir, 'config.json'

    @load()

  load: ->
    @initializeConfigDir()
    @readConfig()

    @emit 'loaded'

  initializeConfigDir: ->
    # If config file already exists, don't need to create it.
    return if fs.existsSync(@_configFilePath)

    # Create directory recursively
    fs.makeTreeSync path.dirname(@_configFilePath)

    # Create empty JSON file
    fs.writeFileSync @_configFilePath, '{}'

  readConfig: ->
    try
      configFile = fs.readFileSync @_configFilePath
      config = JSON.parse configFile
      _.extend @_settings, config

      @emit 'updated'
    catch e
      console.error "Failed to load user config '#{@_configFilePath}#'", e.message
      console.error e.stack

  setDefaults: ->


  ##
  # Modifier
  ##
  get: (key) ->
    dotty.get @_settings, key

  set: (key, value) ->
    edited = dotty.put @_settings, key, value
    if edited
      @emit "updated.#{key}"
      @update()
    return edited

  del: (key) ->
    removed = dotty.remove @_settings, key
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
    fs.writeFileSync @_configFilePath, JSON.stringify(@_settings, null, 2)

module.exports = Config
