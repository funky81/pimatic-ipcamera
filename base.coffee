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
		@array = []
		@createImgDirectory()
		@status=false
		
		resemble.outputSettings({
			errorColor: {
				red: 255,
				green: 0,
				blue: 255
			},
			errorType: 'movement',
			transparency: 0.3,
			largeImageThreshold: 1200
		})
		
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
		,1000*10)
		@array.push ({camera,id})
	snapshot: (camera,id)->
		camera.getScreenshot((err,frame)=>
			try
				@diffPNG = @imgPath+id+"_diff_"+(new Date).getTime()+".jpg"
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
										resemble(@newFile).compareTo(@oldFile)
										.ignoreColors()
										.onComplete((data)=>
											console.log(id, ' with ignore rectangle:', data)
											data.getDiffImage().pack().pipe(fs.createWriteStream(@diffPNG))
											return
										)
										return
								fs.renameSync(@newFilePNG,@oldFilePNG)
							catch errY
									console.log errY
							return
						))
						return
					catch errX
						console.log errX
				)
			catch err
				@plugin.error "error grab frame @getsnapshot function " + err
			return 
		)
		return
		
module.exports = Base