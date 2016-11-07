chai = require "chai"
should = chai.should()

describe "A standard Mocha test", ->

  it "should compare math", ->
    5.should.equal 5

  it "should compare strings", ->
    "foo".should.include "oo"

  it "should have failures", ->
    "foo".should.include "boo"
