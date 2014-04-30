
path = require 'path'
fs = require 'fs'
chai = require 'chai'
assert = chai.assert
expect = chai.expect
chai.should()
chai.use(require('chai-fs'))

requireTest = (path) ->
  require((process.env.APP_SRV_COVERAGE || '../') + path)

requireConfig = -> requireTest('lib/config')
getConfig = (opt) -> new (requireConfig())(opt)

describe 'Config', ->
  [config] = []

  it 'is a class', ->
    expect(requireConfig()).to.be.a('function')

  it 'Can not be instanciate without dir options', ->
    expect(->
      getConfig()
    ).throws('options.dir is mandatory.')


describe 'Config::get', ->
  [config] = []

  before ->
    config = getConfig(dir: path.join(__dirname, './expected/get'))
    config.load()

  it 'Can get a string', ->
    expect(config.get('foo')).to.be.equals('bar')

  it 'Can get an array', ->
    expect(config.get('baz')).to.deep.equal(['a', 'b', 'c'])

  it 'Can get an object', ->
    expect(config.get('bar')).to.deep.equal({'foo': 'bar'})

  it 'Can get a boolean', ->
    expect(config.get('foobar')).to.equal(true)


describe 'Config::set', ->
  [config] = []

  before ->
    config = getConfig(dir: path.join(__dirname, './expected/set'))
    config.load()

  it 'Can set a string', ->
    config.set('foo', 'bar')
    expect(config.get('foo')).to.be.equals('bar')

  it 'Can get an array', ->
    config.set('baz', ['a', 'b', 'c'])
    expect(config.get('baz')).to.deep.equal(['a', 'b', 'c'])

  it 'Can get an object', ->
    config.set('bar', {'foo': 'bar'})
    expect(config.get('bar')).to.deep.equal({'foo': 'bar'})

  it 'Can get a boolean', ->
    config.set('foobar', true)
    expect(config.get('foobar')).to.equal(true)
