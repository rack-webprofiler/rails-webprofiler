# Changelog

## Unplanned

### Features

  * Create a collector for ActionMailer.
  * Create a collector to list jobs created with ActiveJob.
  * Create a collector to show the Rails logger informations.


## v0.1.1

Use `rack-webprofiler` >= `0.1.3`.

### Features

  * Show connection informations on ActiveRecordCollector.

### Fixes

  * Optimize the Railtie implementation.
  * Optimize ActionViewCollector (#10).
  * Load profiler only for Rails 4.2+.
  * Small code cleanup.


## v0.1.0

### Features

  * Friendly UI.
  * ActiveRecord, ActionView, Rails, Request collectors.
