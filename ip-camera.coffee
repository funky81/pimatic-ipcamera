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
			cameraUrl:
				description: "URL of IP Camera"
				type: "string"		
			filename:
				description: "File name of the output"
				type: "string"
			refresh:
				description: "Time to refresh screenshot"
				type: "number"
		template: 'ipcamera'
		
		cameraUrl = ""
		
		constructor: (@config,@plugin) ->
			@id = @config.id
			@name = @config.name
			@filename = @config.filename
			@refresh = @config.refresh
			@cameraUrl = @config.cameraUrl
			super()
			if @refresh > 0
				setInterval( ( => @getSnapshot(@filename) ), 1000*@refresh)
			#@getSnapshot(@filename)
		
		getCameraUrl : -> Promise.resolve(@cameraUrl)	
		getRefresh : -> Promise.resolve(@refresh)
		getFilename: -> Promise.resolve(@filename)
		getSnapshot: (@filename) ->
			camera = new MjpegCamera(url: @cameraUrl)
			camera.getScreenshot((err,frame)=>
				#@plugin.debug "masuk sini lagi..."
				fs.writeFileSync("pimatic-dev\\node_modules\\pimatic-mobile-frontend\\public\\"+@filename, frame)
				return
		  )
			return

	myPlugin = new IpCameraPlugin
	return myPlugin