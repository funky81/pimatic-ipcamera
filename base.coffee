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
		@plugin.info "Called"
		
		
module.exports = Base