module.exports = (env) ->
	Promise = env.require 'bluebird'
	assert = env.require 'cassert'

	class IpCameraPlugin extends env.plugins.Plugin
		init: (app, @framework, @config) =>
			deviceConfigDef = require("./device-config-schema")
			@framework.deviceManager.registerDeviceClass("IpCameraDevice",{
				configDef : deviceConfigDef.IpCameraDevice,
				createCallback : (config) => new IpCameraDevice(config)
			})
			@framework.on "after init", =>
				mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
				if mobileFrontend?
					mobileFrontend.registerAssetFile 'js', "pimatic-ipcamera/app/IpCameraTempl-page.coffee"
					mobileFrontend.registerAssetFile 'html', "pimatic-ipcamera/app/IpCameraTempl-template.html"
					#mobileFrontend.registerAssetFile 'js', "pimatic-ipcamera/rpi/rpicam-item.coffee"
					#mobileFrontend.registerAssetFile 'js', "pimatic-ipcamera/rpi/rpicam-page.coffee"
					#mobileFrontend.registerAssetFile 'html', "pimatic-ipcamera/rpi/rpicam-item.html"
					#mobileFrontend.registerAssetFile 'html', "pimatic-ipcamera/rpi/rpicam-page.jade"
					#mobileFrontend.registerAssetFile 'css', "pimatic-ipcamera/rpi/rpicam.css"
          
	class IpCameraDevice extends env.devices.Device
		attributes:
			message:
				description: "The message to display"
				type: "string"
		template: 'ipcamera'
		constructor: (@config) ->
			@id = @config.id
			@name = @config.name
			super()
		getMessage : -> Promise.resolve(@message)

	myPlugin = new IpCameraPlugin
	return myPlugin