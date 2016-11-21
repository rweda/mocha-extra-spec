chai = require "chai"
should = chai.should()

x = 0
describe "1 Retry", ->
  @retries 1
  afterEach -> yes

  it "should retry", ->
    ++x
    x.should.equal 2
