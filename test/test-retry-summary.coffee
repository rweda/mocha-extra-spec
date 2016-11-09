chai = require "chai"
should = chai.should()

{exec} = require "child-process-promise"

mocha = (opts) ->
  exec "$(npm bin)/mocha --compilers coffee:coffee-script/register --reporter #{__dirname}/../dist/ExtraSpec #{opts}"
    .catch (err) ->
      err

regex =
  summary: /\n ((?:⚠\s)|✓|✖) ([0-9\.]+)\% of attempts passed/

describe "Inline Retry Display", ->

  [run, symbol, percent] = []

  it "should get output from Mocha", ->
    run = mocha "#{__dirname}/files/test-retry.coffee"

  it "should summarize the retries", ->
    run
      .then (res) ->
        res.stdout.should.match regex.summary
        [symbol, percent] = res.stdout.match(regex.summary).slice 1
        symbol.should.equal "✖"
        percent.should.equal Math.min(100, (100 * 2/5).toFixed(2)).toString()
