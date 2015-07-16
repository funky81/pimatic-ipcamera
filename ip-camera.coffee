module.exports = (env) ->
  Promise = env.require 'bluebird'
  assert = env.require 'cassert'

  class IpCameraPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      deviceConfigDef = require("./device-config-schema")
      @framework.deviceManager.registerDeviceClass("IpCamera",{
        configDef : deviceConfigDef.IpCamera,
        createCallback : (config) => new IpCamera(config)
      })

  class IpCamera extends env.devices.Device
    attributes:
      message:
        description: "The message to display"
        type: "string"
    constructor: (@config) ->
      env.logger.info(@config.message)
      @id = @config.id
      @name = @config.name
      @_message = @config.message
      super()
    getMessage : -> Promise.resolve(@_message)

  myPlugin = new IpCameraPlugin
  return myPlugin