
fs = require 'fs-plus'
path = require 'path'
_ = require 'lodash'
assert = require 'assert'

Store = require 'dottystore'

class Config extends Store
  constructor: (options = {}) ->
    super
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
      _.extend @_data, config

      @_update()
    catch e
      console.error "Failed to load user config '#{@_configFilePath}#'", e.message
      console.error e.stack

  _save: ->
    fs.writeFileSync @_configFilePath, JSON.stringify(@_data, null, 2)

module.exports = Config
