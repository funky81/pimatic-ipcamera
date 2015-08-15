#Promise = env.require 'bluebird'
#assert = require 'assert'
#events = require 'events'
resemble = require('node-resemble-js');
images = require('images')
WriteStream = require('stream').Writable
http = require 'http' 
MjpegCamera = require 'mjpeg-camera'
path = require 'path'
fs = require 'fs'
class Base 
	constructor: (framework,config,plugin,app) ->
		@framework = framework
		@config = config
		@plugin = plugin
		@app = app
		#@plugin.info "Called "+@config.devices
		@array = []
		@createImgDirectory()
		@status=false
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
		#@plugin.info @config
		#@plugin.info "Called Again "+ id + "," + name + "," + cameraUrl + username + password
		camera = new MjpegCamera({
			user: username || '',
			password: password || '',
			url: cameraUrl || '',
			name: name || ''})
		#@snapshot(camera,id)
		#camera.start()
		setInterval(()=>
			@snapshot camera,id
			#console.log "snapshot for " + id
		,1000*1)
		@array.push ({camera,id})
	stop : ->
		#console.log "stop function 2"
		@plugin.info "stop function 1"
		#@camera.stop()
		#@status=false
	stop : (camera,id)->
		try
			#console.log "stop function 2"
			@plugin.info "stop function 2"
			#@status=false
			#camera.stop()
			#@snapshot(camera,id)
		catch err
			@plugin.error err
	snapshot: (camera,id)->
		camera.getScreenshot((err,frame)=>
			try
				#console.log "screenshot "+@imgPath+id
				@newFileJPG = @imgPath+id+"_new.jpg"
				@newFilePNG = @imgPath+id+"_new.png"
				@oldFileJPG = @imgPath+id+"_old.jpg"
				@oldFilePNG = @imgPath+id+"_old.png"
				fs.writeFile(@newFileJPG, frame,()=>
					try
						@imgNew = images(@newFileJPG).save(@newFilePNG)
						fs.exists(@oldFilePNG, (exists)=>(
							try
								if (exists)
										@newFile = fs.readFileSync(@newFilePNG)
										@oldFile = fs.readFileSync(@oldFilePNG)
										resemble(@newFile).compareTo(@oldFile).onComplete((data)=>
											console.log('with ignore rectangle:', data)
											data.getDiffImage().pack().pipe(fs.createWriteStream('diffr.png'))
											return
										)
										return
								fs.renameSync(@newFilePNG,@oldFilePNG)
							catch errY
									console.log errY
							return
						))
						return
#						console.log @img.width()
#						console.log "Finished"
						
					catch errX
						console.log errX
				)
			catch err
				@plugin.error "error grab frame @getsnapshot function " + err
			return 
		)
	start : () ->
		#@plugin.info "masuk sini untuk " + @array
		
		@array.forEach((entry)=>
			boundary = '--boundandrebound'
			@app.get('/stream/'+entry["id"],(req,res)=>
				#@plugin.info "masuk sini " + entry["id"]
				#if !@status
				#	entry["camera"].start()
				#	@status=true
				#@plugin.info "masuk sini 2 " + entry["id"]
				res.writeHead(200, {'Content-Type': 'multipart/x-mixed-replace; boundary=' + boundary});
				ws = new WriteStream({objectMode: true})
				ws._write =(chunk, enc, next) ->
					try
						#console.log "masuk sni"
						jpeg = chunk.data
						res.write(boundary + '\nContent-Type: image/jpeg\nContent-Length: '+ jpeg.length + '\n\n')
						res.write(jpeg)
						next()
					catch err
						console.log err
					return
				#@plugin.info entry["camera"].name
				#@plugin.info "masuk sini 3" + entry["id"]
				try
					#@camera = entry["camera"]				
					entry["camera"].pipe(ws)	
				catch err
					console.log err
				#@plugin.info "masuk sini 4" + entry["id"]
				res.on 'close', () =>
					#@camera.stop()
					#@stop(entry["camera"],entry["id"])
					console.log "stop"
					res.end()
					@status=false
					return
				)
		)
		
#		http.createServer((req,res) =>
#			stat = false
#			boundary = '--boundandrebound'
#			@array.forEach((entry)=>
#				try
#					if !stat
#						#@plugin.info "entry : /stream/" + entry["id"] + " "+req.url
#						if (("/stream/"+entry["id"]).toLowerCase()==req.url.toLowerCase()) 
#							#@plugin.info "Start Stream for Camera "+entry["camera"].name
#							#@snapshot(entry["camera"],entry["id"])
#							entry["camera"].start()
#							res.writeHead(200, {'Content-Type': 'multipart/x-mixed-replace; boundary=' + boundary});
#							ws = new WriteStream({objectMode: true})
#							ws._write =(chunk, enc, next) ->
#								#@plugin.info "masuk sni"
#								jpeg = chunk.data
#								res.write(boundary + '\nContent-Type: image/jpeg\nContent-Length: '+ jpeg.length + '\n\n')
#								res.write(jpeg)
#								next()
#								return
#							#@plugin.info entry["camera"].name
#							entry["camera"].pipe(ws)
#							res.on 'close', () =>
#								#console.log "stop"
#								@stop(entry["camera"],entry["id"])
#								return
#							stat=true
#						else if (("/page/"+entry["id"]).toLowerCase()==req.url.toLowerCase()) 
#							res.writeHead(200, {'Content-Type': 'text/html'})
#							res.end('<!doctype html>\
#								<html>\
#									<head>\
#										<title>'+entry["camera"].name+'</title>\
#									</head>\
#									<body style="background:#000;">\
#										<img src="/stream" style="width:100%;height:auto;">\
#									</body>\
#								</html>')
#						return
#				catch err
#					#@plugin.info "error : " + err
#					@plugin.error "error: " + err
#			)
#		).listen(10000)



		return
		
module.exports = Base