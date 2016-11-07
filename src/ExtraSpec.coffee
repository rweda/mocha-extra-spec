ms = require "mocha/lib/ms"
Spec = require "mocha/lib/reporters/spec.js"
Base = require "mocha/lib/reporters/base.js"
{symbols, color} = Base

symbols.warning = "⚠"
if process.platform is 'win32'
  symbols.warning = "!"

class ExtraSpec extends Spec

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

    console.log()

module.exports = ExtraSpec
