$(document).on( "templateinit", (event) ->
  # define the item class
	done = false
	class IpCameraDeviceItem extends pimatic.DeviceItem
		constructor: (templData, @device) ->
			@delay=5
			@id = @device.id
			@imgId = "img"+@device.id
			@name = @device.name
			@filename = "/img/"+@id+".jpg"
			@width = @device.config.width  ? @device.configDefaults.width
			@height = @device.config.height ? @device.configDefaults.height 
			@refresh = @device.config.refresh
			@socket = io.connect("#{document.location.host}/")
			@socket.on("snapshot"+@id,(data)=>
				if (data == @id && !done)
					done = true
					console.log "Refresh : "+ @imgId + ", data : " + data
					$(".img_"+@imgId).attr("src",@filename + "?ts="+ new Date().getTime())
			)
			@socket.on("streaming"+@id,(data)=>
				done = false
			)
			super(templData,@device)
		afterRender : (elements) ->
			super(elements)
			#@refreshButton = $(elements).find('[name=refreshButton]')			
		stopStream : -> @streamCommand "stop"
		startStream : -> @streamCommand "start"
		refreshStream : -> @streamCommand "refresh"
		changeSelect :(obj,event) -> 
			@delay = event.target.value
			console.log @delay
			$(".select_"+@imgId).val(@delay)
		streamCommand: (command) ->
			if command == "start"
				@device.rest.streamCommand({command,@delay}, global: no)
				return
			else if command == "stop"
				@device.rest.otherCommand({command}, global: no)
				return
			else if command == "refresh"
				console.log "Refresh Stream for Camera "+ @imgId
				@device.rest.otherCommand({command}, global: no)
			done = false
			return
		updateImage : (command) ->
			return
  
  # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
