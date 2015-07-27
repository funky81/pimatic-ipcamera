#Promise = env.require 'bluebird'
#assert = require 'assert'
#events = require 'events'
WriteStream = require('stream').Writable
http = require 'http' 
MjpegCamera = require 'mjpeg-camera'
path = require 'path'
fs = require 'fs'
class Base 
	constructor: (framework,config,plugin) ->
		@framework = framework
		@config = config
		@plugin = plugin
		#@plugin.info "Called "+@config.devices
		@array = []
		@createImgDirectory()
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
	add : (@id,@name,@cameraUrl) ->
		#@plugin.info "Called Again "+ @id + "," + @name + "," + @cameraUrl
		camera = new MjpegCamera({url: @cameraUrl,name: @name})
		@snapshot(camera,@id)
		@array.push ({camera,@id})
	stop : (camera,id)->
		#console.log "stop function"
		camera.stop()
		@snapshot(camera,id)
	snapshot: (camera,id)->
		camera.getScreenshot((err,frame)=>
			try
				#console.log "screenshot "+@imgPath+id
				fs.writeFileSync(@imgPath+id+".jpg", frame)
			catch err
				@plugin.error "error grab frame @getsnapshot function " + err
			return 
		)
	start : () ->
		#@plugin.info "masuk sini untuk " + @array
		http.createServer((req,res) =>
			stat = false
			boundary = '--boundandrebound'
			@array.forEach((entry)=>
				try
					if !stat
						#@plugin.info "entry : /stream/" + entry["id"] + " "+req.url
						if (("/stream/"+entry["id"]).toLowerCase()==req.url.toLowerCase()) 
							#@plugin.info "Start Stream for Camera "+entry["camera"].name
							#@snapshot(entry["camera"],entry["id"])
							entry["camera"].start()
							res.writeHead(200, {'Content-Type': 'multipart/x-mixed-replace; boundary=' + boundary});
							ws = new WriteStream({objectMode: true})
							ws._write =(chunk, enc, next) ->
								#@plugin.info "masuk sni"
								jpeg = chunk.data
								res.write(boundary + '\nContent-Type: image/jpeg\nContent-Length: '+ jpeg.length + '\n\n')
								res.write(jpeg)
								next()
								return
							#@plugin.info entry["camera"].name
							entry["camera"].pipe(ws)
							res.on 'close', () =>
								#console.log "stop"
								@stop(entry["camera"],entry["id"])
								return
							stat=true
						else if (("/page/"+entry["id"]).toLowerCase()==req.url.toLowerCase()) 
							res.writeHead(200, {'Content-Type': 'text/html'})
							res.end('<!doctype html>\
								<html>\
									<head>\
										<title>'+entry["camera"].name+'</title>\
									</head>\
									<body style="background:#000;">\
										<img src="/stream" style="width:100%;height:auto;">\
									</body>\
								</html>')
						return
				catch err
					@plugin.info "error : " + err
					@plugin.error "error: " + err
			)
		).listen(10000)
		return
		
		
		
module.exports = Base