module.exports = (env) ->

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'


  class IpCameraPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      env.logger.info("Hello World")

  # ###Finally
  # Create a instance of my plugin
  myPlugin = new IpCameraPlugin
  # and return it to the framework.
  return myPlugin