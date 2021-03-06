// Generated by CoffeeScript 1.11.1
(function() {
  var Base, ExtraSpec, Spec, color, colors, ms, symbols,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  ms = require("mocha/lib/ms");

  Spec = require("mocha/lib/reporters/spec.js");

  Base = require("mocha/lib/reporters/base.js");

  symbols = Base.symbols, color = Base.color, colors = Base.colors;

  colors.retry = 35;

  symbols.bang = "⚠ ";

  if (process.platform === 'win32') {
    symbols.bang = "!";
  }


  /*
  Determine the message color based on a percent.  1 is the best, 0 is the worst.
   */

  color.byPercent = function(percent) {
    switch (false) {
      case percent !== 1:
        return "bright pass";
      case !(percent > 0.9):
        return "pass";
      case !(percent > 0.6):
        return "medium";
      case !(percent > 0.3):
        return "bright yellow";
      default:
        return "fail";
    }
  };


  /*
  Determine the message symbol based on a percent.  1 is the best, 0 is the worst.
   */

  symbols.byPercent = function(percent) {
    switch (false) {
      case percent !== 1:
        return symbols.ok;
      case !(percent > 0.5):
        return symbols.bang;
      default:
        return symbols.err;
    }
  };

  ExtraSpec = (function(superClass) {
    extend(ExtraSpec, superClass);

    function ExtraSpec(runner) {
      this.addRetry = bind(this.addRetry, this);
      this.indents = 0;
      ExtraSpec.__super__.constructor.call(this, runner);
      runner.on('suite', (function(_this) {
        return function() {
          return ++_this.indents;
        };
      })(this));
      runner.on('suite end', (function(_this) {
        return function() {
          return --_this.indents;
        };
      })(this));
      runner.on('pass', this.addRetry);
      runner.on('fail', this.addRetry);
    }

    ExtraSpec.prototype.indent = function() {
      return Array(this.indents).join('  ');
    };


    /*
    When a test passes or fails, add the number of retries to the stats.
     */

    ExtraSpec.prototype.addRetry = function(test) {
      var base;
      if ((base = this.stats).retries == null) {
        base.retries = 0;
      }
      this.stats.retries += test.currentRetry();
      if (test.currentRetry() > 0) {
        return console.log(this.indent() + color("retry", "  " + symbols.bang) + (" Retried " + (test.currentRetry()) + " times"));
      }
    };


    /*
    Print out a percentage, with a symbol and custom message.
    @param {Number} percent the percent to print, 0-1
    @param {Boolean} flip **Optional** if `false` (default), uses good symbols for 1, and bad symbols for 0.
      Provide `true` to make 0 good, and 1 bad.
    @param {String} msg a message to print after the percentage.  '%s' will be substituted with the percent.
     */

    ExtraSpec.prototype.printPercent = function(percent, flip, msg) {
      var c, p, ref, symbol;
      if (flip == null) {
        flip = false;
      }
      if (typeof flip === "string") {
        ref = [flip, false], msg = ref[0], flip = ref[1];
      }
      p = percent * (flip ? -1 : 1);
      c = color.byPercent(p);
      symbol = symbols.byPercent(p);
      percent = Math.min(100, (percent * 100).toFixed(2));
      return console.log(color(c, " " + symbol + " " + msg), percent);
    };


    /*
    Print out the percent of tests that passed.
     */

    ExtraSpec.prototype.printFailurePercent = function() {
      var passes, total;
      total = this.stats.tests;
      passes = this.stats.passes;
      return this.printPercent(passes / total, "%s% of tests passed");
    };


    /*
    Print out the percent of tests that passed, including the number of retried tests in the count.
     */

    ExtraSpec.prototype.printTestPercent = function() {
      var passes, total;
      total = this.stats.retries + this.stats.tests;
      passes = this.stats.passes;
      return this.printPercent(passes / total, "%s% of attempts passed");
    };


    /*
    Prints out statistics about the testing, and prints the error log.  Called after all tests have finished.
     */

    ExtraSpec.prototype.epilogue = function() {
      console.log();
      console.log("" + (color('bright pass', ' ')) + (color('green', ' %d passing')) + (color('light', ' (%s)')), this.stats.passes || 0, ms(this.stats.duration));
      if (this.stats.pending) {
        console.log("" + (color('pending', ' ')) + (color('pending', '%d pending')), this.stats.pending);
      }
      if (this.stats.failures) {
        console.log("" + (color('fail', '  %d failing')), this.stats.failures);
        Base.list(this.failures);
        console.log();
      }
      this.printFailurePercent();
      this.printTestPercent();
      return console.log();
    };

    return ExtraSpec;

  })(Spec);

  module.exports = ExtraSpec;

}).call(this);
