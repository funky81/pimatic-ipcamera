module.exports = (env) ->
	Promise = env.require 'bluebird'
	assert = env.require 'cassert'
	MjpegCamera = require 'mjpeg-camera'
	fs = env.require 'fs'
	Base = require('./base')

	class IpCameraPlugin extends env.plugins.Plugin
		init: (app, @framework, @config) =>
			@base = new Base(@framework, @config, this,app)
			deviceConfigDef = require("./device-config-schema")
			@framework.deviceManager.registerDeviceClass("IpCameraDevice",{
				configDef : deviceConfigDef.IpCameraDevice,
				createCallback : (config) => new IpCameraDevice(config,this,@base)
			})
			#@framework.ruleManager.addActionProvider(new IpCameraActionProvider(@framework))
			@framework.on "after init", =>
				mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
				if mobileFrontend?
					mobileFrontend.registerAssetFile 'js', "pimatic-ipcamera/app/IpCameraTempl-page.coffee"
					mobileFrontend.registerAssetFile 'html', "pimatic-ipcamera/app/IpCameraTempl-template.html"
				@base.start()
				return
		info: (text) ->
			env.logger.info text
			return
		error: (text) ->
			env.logger.error text
			return			
		debug: (text) ->
			env.logger.debug text
			return
		replaceAll: (x,s,r) -> 
			return x.split(s).join(r)
			
	class IpCameraDevice extends env.devices.Device
		attributes:
			username:
				description: "User name for the access"
				type: "string"
				default: ""
			password:
				description: "password for the access"
				type: "string"
				default: ""
			cameraUrl:
				description: "URL of IP Camera"
				type: "string"		
			filename:
				description: "File name of the output"
				type: "string"
			refresh:
				description: "Time to refresh screenshot"
				type: "number"
				default: 0
			width:
				description: "Width of the Image"
				type: "number"				
				default : 240
			height:
				description: "Height of the Image"
				type: "number"	
				default : 160											
		actions:
			streamCommand:
				description: "Command for streaming"
				params: 
					command: 
						type: "string"				
		template: 'ipcamera'
		isCreateDir = false
		constructor: (@config,@plugin,@base) ->
			@id = @config.id
			@name = @config.name
			@filename = @config.filename
			@refresh = @config.refresh
			@cameraUrl = @config.cameraUrl
			@width = @config.width
			@height = @config.height
			@username = @config.username
			@password = @config.password
			@base.add(@id,@name,@cameraUrl,@username,@password)
			super()
			
		getWidth: -> Promise.resolve(@width)
		getHeight: -> Promise.resolve(@height)
		getCameraUrl : -> Promise.resolve(@cameraUrl)	
		getRefresh : -> Promise.resolve(@refresh)
		getFilename: -> Promise.resolve(@filename)
		getUsername: -> Promise.resolve(@username)
		getPassword: -> Promise.resolve(@password)
		streamCommand : (command) ->
			if command == "stop"
				@plugin.info "Stop Stream for Camera "+ @name
				#@base.stop()
			else
				@plugin.info "Start Stream for Camera "+ @name
				#@base.start()
						
	class IpCameraActionProvider extends env.actions.ActionProvider
		constructor: (@framework)->
			#env.logger.info "Masuk sini constructor"
			return
		executeAction: (simulate) =>
			#env.logger.info "Masuk sini executeAction"
			return
		parseAction: (input,context)->
			#env.logger.info "Masuk sini parseAction"
			return

	myPlugin = new IpCameraPlugin
	return myPlugin