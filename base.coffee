WriteStream = require('stream').Writable
http = require 'http' 
MjpegCamera = require 'mjpeg-camera'
path = require 'path'
fs = require 'fs'
events = require("events")
EventEmitter = require("events").EventEmitter

class Base 
	constructor: (framework,config,plugin,app) ->
		@framework = framework
		@config = config
		@plugin = plugin
		@app = app
		@array = []
		@createImgDirectory()
		@status=false
		@io = framework.io
	createImgDirectory: ->
		@imgPath = ""
		if process.platform in ['win32', 'win64']
			@imgPath = path.dirname(fs.realpathSync(__filename+"\\..\\"))+"\\pimatic-mobile-frontend\\public\\img\\"
		else
			@imgPath = path.dirname(fs.realpathSync(__filename+"/../"))+"/pimatic-mobile-frontend/public/img/"			
		fs.exists(@imgPath,(exists)=>
			if !exists 
				fs.mkdir(@imgPath,(stat)=>
					@plugin.info "Create directory for the first time"
				)
		)

	add : (id,name,cameraUrl,username,password) ->
		camera = new MjpegCamera({
			user: username || '',
			password: password || '',
			url: cameraUrl || '',
			name: name || ''})
		setInterval(()=>
			@snapshot camera,id
			#console.log "snapshot for " + id
			@io.emit("refresh")
		,1000*1)
		@array.push ({camera,id})
	snapshot: (camera,id)->
		camera.getScreenshot((err,frame)=>
			try
				fs.writeFile(@imgPath+id+".jpg", frame)
			catch err
				@plugin.error "error grab frame @getsnapshot function " + err
			return 
		)

		return
		
module.exports = Base