ms = require "mocha/lib/ms"
Spec = require "mocha/lib/reporters/spec.js"
Base = require "mocha/lib/reporters/base.js"
{symbols, color} = Base

symbols.bang = "⚠ "
if process.platform is 'win32'
  symbols.bang = "!"

###
Determine the message color based on a percent.  1 is the best, 0 is the worst.
###
color.byPercent = (percent) ->
  switch
    when percent is 1 then "bright pass"
    when percent > 0.9 then "pass"
    when percent > 0.6 then "medium"
    when percent > 0.3 then "bright yellow"
    else "fail"

###
Determine the message symbol based on a percent.  1 is the best, 0 is the worst.
###
symbols.byPercent = (percent) ->
  switch
    when percent is 1 then symbols.ok
    when percent > 0.5 then symbols.bang
    else symbols.err

class ExtraSpec extends Spec

  ###
  Print out a percentage, with a symbol and custom message.
  @param {Number} percent the percent to print, 0-1
  @param {Boolean} flip **Optional** if `false` (default), uses good symbols for 1, and bad symbols for 0.
    Provide `true` to make 0 good, and 1 bad.
  @param {String} msg a message to print after the percentage.  '%s' will be substituted with the percent.
  ###
  printPercent: (percent, flip=no, msg) ->
    if typeof flip is "string"
      [msg, flip] = [flip, no]
    p = percent * (if flip then -1 else 1)
    c = color.byPercent p
    symbol = symbols.byPercent p
    percent = (percent * 100).toFixed 2
    console.log color(c, " #{symbol} #{msg}"), percent

  ###
  Print out the percent of tests that passed.
  ###
  printFailurePercent: ->
    total = @stats.tests
    passes = @stats.passes
    @printPercent passes / total, "%s% of tests passed"

  ###
  Prints out statistics about the testing, and prints the error log.  Called after all tests have finished.
  ###
  epilogue: ->
    console.log()

    console.log "#{color 'bright pass', ' '}#{color 'green', ' %d passing'}#{color 'light', ' (%s)'}",
      @stats.passes || 0, ms @stats.duration

    if @stats.pending
      console.log "#{color 'pending', ' '}#{color 'pending', '%d pending'}", @stats.pending

    if @stats.failures
      console.log "#{color 'fail', '  %d failing'}", @stats.failures
      Base.list @failures
      console.log()

    @printFailurePercent()

    console.log()

module.exports = ExtraSpec
