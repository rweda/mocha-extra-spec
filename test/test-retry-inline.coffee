chai = require "chai"
should = chai.should()

{exec} = require "child-process-promise"

mocha = (opts) ->
  exec "$(npm bin)/mocha --compilers coffee:coffee-script/register --reporter #{__dirname}/../dist/ExtraSpec #{opts}"
    .catch (err) ->
      err

describe "Inline Retry Display", ->
  run = mocha "#{__dirname}/files/test-retry.coffee"

  it "should show 1 retry", ->
    run
      .then (res) ->
        res.stdout.should.include """
            1 Retry
                ✓ should retry
                ⚠  Retried 1 times
        """

  it "should show 2 retries", ->
    run
      .then (res) ->
        res.stdout.should.include """
            2 Retries
                ✓ should retry
                ⚠  Retried 2 times
        """
