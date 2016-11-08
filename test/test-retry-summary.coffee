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
  run = mocha "#{__dirname}/files/test-retry.coffee"
  [symbol, percent] = []

  it "should summarize the retries", ->
    run
      .then (res) ->
        res.stdout.should.match regex.summary
        [symbol, percent] = res.stdout.match(regex.summary).slice 1
        symbol.should.equal "✖"
        percent.should.equal Math.min(100, (100 * 2/5).toFixed(2)).toString()
