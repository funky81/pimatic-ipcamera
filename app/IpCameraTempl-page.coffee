$(document).on( "templateinit", (event) ->
  # define the item class
	class IpCameraDeviceItem extends pimatic.DeviceItem
		constructor: (templData, @device) ->
			@x=0
			uId = ""
			@id = @device.id
			@imgId = "img"+@device.id
			@name = @device.name
			@filename = "/img/"+@id+".jpg"
			@width = @device.config.width  ? @device.configDefaults.width
			@height = @device.config.height ? @device.configDefaults.height 
			@refresh = @device.config.refresh
			super(templData,@device)
		afterRender : (elements) ->
			super(elements)
			@refreshButton = $(elements).find('[name=refreshButton]')
		stopStream : -> @streamCommand "stop"
		startStream : -> @streamCommand "start"
		refreshStream : -> @streamCommand "refresh"
		streamCommand: (command) ->
			if command == "start"
				if @x == 0
					console.log "Start Stream for "+ @imgId
					$('#startButton').bind('click', false);
					@x=setInterval((=>
						$("."+@imgId).attr("src",@filename + "?ts="+ new Date().getTime())
						console.log "Repeat for "+ @filename
					),1000)
			else if command == "stop"
				console.log "Stop Stream for "+ @imgId
				clearInterval(@x)
				@x=0
			else if command == "refresh"
				$('#startButton').bind('click', true);
				console.log "Refresh Stream for Camera "+ @imgId
				clearInterval(@x)
				@x=0
				$("."+@imgId).attr("src",@filename + "?ts="+ new Date().getTime()) 
			@device.rest.streamCommand({command}, global: no)						
			return
		updateImage : (command) ->
			return
  
  # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
