chai = require "chai"
should = chai.should()

x = 0
describe "1 Retry", ->
  @retries 1

  it "should retry", ->
    ++x
    x.should.equal 2

y = 0
describe "2 Retries", ->
  @retries 2

  it "should retry", ->
    ++y
    y.should.equal 3
