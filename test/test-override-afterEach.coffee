chai = require "chai"
should = chai.should()

{exec} = require "child-process-promise"

mocha = (opts) ->
  exec "$(npm bin)/mocha --compilers coffee:coffee-script/register --reporter #{__dirname}/../dist/ExtraSpec #{opts}"
    .catch (err) ->
      err

regex =
  summary: /\n ((?:⚠\s)|✓|✖) ([0-9\.]+)\% of attempts passed/

describe "Test with Overriding afterEach", ->

  run = null

  it "should get output from Mocha", ->
    run = mocha "#{__dirname}/files/test-override-afterEach.coffee"

  it "should show 1 retry", ->
    run
      .then (res) ->
        res.stdout.should.include """
            1 Retry
                ✓ should retry
                ⚠  Retried 1 times
        """

  it "should summarize the retries", ->
    run
      .then (res) ->
        res.stdout.should.match regex.summary
        [symbol, percent] = res.stdout.match(regex.summary).slice 1
        symbol.should.equal "✖"
        percent.should.equal Math.min(100, (100 * 1/2).toFixed(2)).toString()

