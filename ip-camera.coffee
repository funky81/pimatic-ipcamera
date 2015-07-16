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
			@framework.on "after init", =>
				mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
				if mobileFrontend?
					mobileFrontend.registerAssetFile 'js', "pimatic-ipcamera/app/IpCameraTempl-page.coffee"
					mobileFrontend.registerAssetFile 'html', "pimatic-ipcamera/app/IpCameraTempl-template.html"

	class IpCamera extends env.devices.Device
		attributes:
			message:
				description: "The message to display"
				type: "string"
		template: 'IpCameraTempl'
		constructor: (@config) ->
			@id = @config.id
			@name = @config.name
			super()
		getMessage : -> Promise.resolve(@message)

	myPlugin = new IpCameraPlugin
	return myPlugin