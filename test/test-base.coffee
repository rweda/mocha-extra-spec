Promise = require "bluebird"
chai = require "chai"
should = chai.should()

{exec} = require "child-process-promise"

mocha = (opts) ->
  exec "$(npm bin)/mocha --compilers coffee:coffee-script/register #{opts}"
    .catch (err) ->
      err

regex =
  testsPassed: /\n ((?:⚠\s)|✓|✖) ([0-9\.]+)\% of tests passed/
  attemptsPassed: /\n ((?:⚠\s)|✓|✖) ([0-9\.]+)\% of attempts passed/

describe "ExtraSpec with a basic example", ->

  [extra, spec, output] = []

  it "should get output from Mocha", ->
    extra = mocha "--reporter #{__dirname}/../dist/ExtraSpec #{__dirname}/files/test-standard.coffee"
    spec = mocha "--reporter spec #{__dirname}/files/test-standard.coffee"
    output = Promise
      .join extra, spec
      .map (res) ->
        res.safeStdout = res.stdout
          .replace(/([0-9]+)ms/, "xms") # Replace '20ms' with 'xms' to standardize across runs
          .replace(regex.testsPassed, '') # Remove extra output
          .replace(regex.attemptsPassed, '')
        res

  it "should mostly match Spec's stdout", ->
    output
      .then ([extra, spec]) ->
        extra.safeStdout.should.equal spec.safeStdout

  it "should match Spec's stderr", ->
    output
      .then ([extra, spec]) ->
        extra.stderr.should.equal spec.stderr

  it "should include percentage of passing tests", ->
    extra.then (res) ->
      res.stdout.should.match regex.testsPassed
      [symbol, number] = res.stdout.match(regex.testsPassed).slice 1
      symbol.should.equal "⚠ "
      number.should.equal "66.67"
