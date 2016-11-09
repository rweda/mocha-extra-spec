# Mocha ExtraSpec
Mocha's spec reporter with retry stats and percentages.

[![Build Status](https://travis-ci.org/rweda/mocha-extra-spec.svg?branch=master)](https://travis-ci.org/rweda/mocha-extra-spec)

![screenshot](screenshot.png)

## Features

- **Visible Retries**
  Retries can waste time and hide stability issues.  Instead of ignoring them, the number of retries attempted is
  displayed under each test.
- **Percentage Summary**
  Instead of marking retries as successful and moving on, the summary includes a simple percentage of failed attempts
  (including both successful and unsuccessful runs).
  This can even be included in CI as a coverage statistic, to reflect the overall health of the build.

## Usage

```sh
npm install --save-dev mocha extra-spec
mocha --reporter extra-spec
```
