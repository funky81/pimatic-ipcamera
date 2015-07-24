module.exports = (env) ->
	Promise = env.require 'bluebird'
	assert = env.require 'cassert'
	MjpegCamera = require 'mjpeg-camera'
	fs = env.require 'fs'
	path = env.require 'path'

	class IpCameraPlugin extends env.plugins.Plugin
		init: (app, @framework, @config) =>
			deviceConfigDef = require("./device-config-schema")
			@framework.deviceManager.registerDeviceClass("IpCameraDevice",{
				configDef : deviceConfigDef.IpCameraDevice,
				createCallback : (config) => new IpCameraDevice(config,this)
			})
			#@framework.ruleManager.addActionProvider(new IpCameraActionProvider(@framework))
			@framework.on "after init", =>
				mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
				if mobileFrontend?
					mobileFrontend.registerAssetFile 'js', "pimatic-ipcamera/app/IpCameraTempl-page.coffee"
					mobileFrontend.registerAssetFile 'html', "pimatic-ipcamera/app/IpCameraTempl-template.html"
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
			sendCommand:
				description: "action for camera"
				params: 
					command: 
						type: "string"				
		template: 'ipcamera'
		isCreateDir = false
		constructor: (@config,@plugin) ->
			@id = @config.id
			@name = @config.name
			@filename = @config.filename
			@refresh = @config.refresh
			@cameraUrl = @config.cameraUrl
			@width = @config.width
			@height = @config.height
			#@getSnapshot(@filename)
			#if @refresh > 0
			#	@getSnapshot(@filename)
			#	setInterval( ( => @getSnapshot(@filename) ), 1000*@refresh)
			@imgPath = ""
			if process.platform in ['win32', 'win64']
				@imgPath = path.dirname(fs.realpathSync(__filename+"\\..\\"))+"\\pimatic-mobile-frontend\\public\\img\\"
			else
				@imgPath = path.dirname(fs.realpathSync(__filename+"/../"))+"/pimatic-mobile-frontend/public/img/"			
			fs.exists(@imgPath,(exists)=>
				if !exists 
					@plugin.info "masuk sini lagi " + exists
					try 
						if isCreateDir == false
							fs.mkdir(@imgPath,(stat)=>
								@plugin.info "Create directory for the first time"
							)
							isCreateDir = true
					catch fsErr
						@plugin.error "error because " + fsErr
			)
			super()
			
		getWidth: -> Promise.resolve(@width)
		getHeight: -> Promise.resolve(@height)
		getCameraUrl : -> Promise.resolve(@cameraUrl)	
		getRefresh : -> Promise.resolve(@refresh)
		getFilename: -> Promise.resolve(@filename)
		getSnapshot: (@filename) ->
			#@plugin.info "beginning of get snapshot " + @filename
			try
				camera = new MjpegCamera(url: @cameraUrl)
				#@plugin.info "after beginning of get snapshot " + @filename
			catch xxx
				@plugin.error "error @snapshot " + @filename + ":" + xxx
			camera.getScreenshot((err,frame)=>
				#@plugin.info err
				try
					#@plugin.info "enter get screenshot process for " + @filename
					fs.writeFileSync(@imgPath+@filename, frame)
					return true
				catch err
					@plugin.error "error grab frame @getsnapshot function " + err
					return false
		  )
			return
		sendCommand: (command) ->
			#@plugin.info "get snapshot from "+@filename
			stat = @getSnapshot(@filename)
			return stat
			
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