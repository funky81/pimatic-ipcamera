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
		@interval=0
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

	add : (id,name,cameraUrl,username,password,leftURL,rightURL,upURL,downURL) ->
		camera = new MjpegCamera({
			user: username || '',
			password: password || '',
			url: cameraUrl || '',
			name: name || ''})
		@array.push ({camera,id})
		@leftURL = leftURL
		@rightURL = rightURL
		@upURL = upURL
		@downURL = downURL
	snapshot: (camera,id)->
		camera.getScreenshot((err,frame)=>
			try
				fs.writeFile(@imgPath+id+".jpg", frame,()=>
#					@plugin.info "screenshot for each : " + id
					@io.emit("snapshot"+id,id)
				)
			catch err
				@plugin.error "error grab frame @getsnapshot function " + err
			return 
		)
		return
	capture : (id) ->
		@stopStreaming id
#		@plugin.info "outer for each : " + id
		@array.forEach((entry) =>
			if (entry["id"]==id)
#				@plugin.info "for each : " + entry["id"]
				camera = entry["camera"]
				@snapshot camera,id
		)
	streamingCapture : (id,delay) ->
		@stopStreaming id
		@delay = delay
#		@plugin.info "outer for each : " + id
		@array.forEach((entry) =>
			if (entry["id"]==id)
#				@plugin.info "for each : " + entry["id"]
				camera = entry["camera"]
				@interval = setInterval(()=>
					@snapshot camera,id
					console.log "snapshot for " + id
					@io.emit("streaming"+id,id)
				,1000*@delay)
		)
	stopStreaming : (id) ->
		@plugin.info "stop streaming for id : " + id
		clearInterval(@interval)
		@interval = 0
	moveCamera : (url) ->
		req = http.get url, (res) ->
			status = res.statusCode
			value = if status == 200 then 1 else 0
			if status == 200
#				return @plugin.info "Successfully moved"
			else
#				return @plugin.info "Error in moving"
			return
		req.on 'error', ->
#			return @plugin.error "An error occurred"
		@plugin.info "Done"
	
module.exports = Base