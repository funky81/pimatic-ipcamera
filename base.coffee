#Promise = env.require 'bluebird'
#assert = require 'assert'
#events = require 'events'
WriteStream = require('stream').Writable
http = require 'http' 
MjpegCamera = require 'mjpeg-camera'

class Base 
	constructor: (framework,config,plugin) ->
		@framework = framework
		@config = config
		@plugin = plugin
		#@plugin.info "Called "+@config.devices
		@array = []
	add : (@id,@name,@cameraUrl) ->
		#@plugin.info "Called Again "+ @id + "," + @name + "," + @cameraUrl
		camera = new MjpegCamera({url: @cameraUrl,name: @name})
		@array.push ({camera,@id})
	start : () ->
		#@plugin.info "masuk sini untuk " + @array
		http.createServer((req,res) =>
			stat = false
			boundary = '--boundandrebound'
			@array.forEach((entry)=>
				if !stat
					@plugin.info "entry : /stream/" + entry["id"] + " "+req.url
					if (("/stream/"+entry["id"]).toLowerCase()==req.url.toLowerCase()) 
						#@plugin.info "masuk yuks"
						res.writeHead(200, {'Content-Type': 'multipart/x-mixed-replace; boundary=' + boundary});
						ws = new WriteStream({objectMode: true});
						stat=true
					else
						res.writeHead(200, {'Content-Type': 'text/html'})
					return
			)
		).listen(10000)
		return
		
		
		
module.exports = Base