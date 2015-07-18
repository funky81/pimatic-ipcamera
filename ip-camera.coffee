module.exports = (env) ->
	Promise = env.require 'bluebird'
	assert = env.require 'cassert'
	MjpegCamera = env.require 'mjpeg-camera'
	fs = env.require 'fs'

	class IpCameraPlugin extends env.plugins.Plugin
		init: (app, @framework, @config) =>
			deviceConfigDef = require("./device-config-schema")
			@framework.deviceManager.registerDeviceClass("IpCameraDevice",{
				configDef : deviceConfigDef.IpCameraDevice,
				createCallback : (config) => new IpCameraDevice(config,this)
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
		debug: (text) =>
			env.logger.info text
			
	class IpCameraDevice extends env.devices.Device
		attributes:
			message:
				description: "The message to display"
				type: "string"
			filename:
				description: "File name of the output"
				type: "string"
		template: 'ipcamera'
		
		filenameX = "asdasdas"
		cameraUrl = ""
		
		constructor: (@config,@plugin) ->
			@id = @config.id
			@name = @config.name
			@filename = @config.filename
			cameraUrl = 'http://jarvis.keluargareski.net:50803/?action=stream'
			super()
			setInterval( ( => @getSnapshot(@filename) ), 1000*5)
			
		getMessage : -> Promise.resolve(@message)
		getFilename: -> Promise.resolve(@filename)
		getSnapshot: (@filename) ->
			camera = new MjpegCamera(url: cameraUrl)
			camera.getScreenshot((err,frame)=>
				fs.writeFileSync(@filename, frame)
				return
		  )
			return

	myPlugin = new IpCameraPlugin
	return myPlugin