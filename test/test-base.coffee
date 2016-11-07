Promise = require "bluebird"
chai = require "chai"
should = chai.should()

{exec} = require "child-process-promise"

mocha = (opts) ->
  exec "$(npm bin)/mocha --compilers coffee:coffee-script/register #{opts}"
    .catch (err) ->
      err

describe "ExtraSpec with a basic example", ->

  extra = mocha "--reporter #{__dirname}/../dist/ExtraSpec #{__dirname}/files/test-standard.coffee"
  spec = mocha "--reporter spec #{__dirname}/files/test-standard.coffee"

  output = Promise
    .join extra, spec
    .map (res) ->
      res.stdout = res.stdout.replace(/([0-9]+)ms/, "xms")
      res

  it "should match Spec's stdout", ->
    output
      .then ([extra, spec]) ->
        extra.stdout.should.equal spec.stdout

  it "should match Spec's stderr", ->
    output
      .then ([extra, spec]) ->
        extra.stderr.should.equal spec.stderr
