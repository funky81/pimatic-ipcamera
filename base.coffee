#Promise = env.require 'bluebird'
#assert = require 'assert'
#events = require 'events'

http = require 'http' 
MjpegCamera = require 'mjpeg-camera'

class Base 
	constructor: (framework,config,plugin) ->
		@framework = framework
		@config = config
		@plugin = plugin
		@plugin.info "Called "+@config.devices
		@array = []
	add : (@id,@name,@cameraUrl) ->
		@plugin.info "Called Again "+ @id + "," + @name + "," + @cameraUrl
		camera = new MjpegCamera(url: @cameraUrl)
		@array.push camera,@id,@name,@cameraUrl
	start : () ->
		@plugin.info "masuk sini untuk " + @array
		http.createServer((req,res) =>
			res.writeHead(200, {'Content-Type': 'text/html'});
			res.write ("success")
			res.end()
			return
		).listen(10000)
		return
		
		
		
module.exports = Base