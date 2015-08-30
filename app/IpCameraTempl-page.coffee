$(document).on( "templateinit", (event) ->
  # define the item class
	class IpCameraDeviceItem extends pimatic.DeviceItem
		constructor: (templData, @device) ->
			@x=0
			uId = ""
			@delay=5
			@id = @device.id
			@imgId = "img"+@device.id
			@name = @device.name
			@filename = "/img/"+@id+".jpg"
			@width = @device.config.width  ? @device.configDefaults.width
			@height = @device.config.height ? @device.configDefaults.height 
			@refresh = @device.config.refresh
			@socket = io.connect('http://localhost:8080')
			@socket.on("refresh",()->
				console.log "Refresh"
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
				if @x == 0
					console.log "Start Stream for "+ @imgId
#					@delay = $( "#"+@imgId+ " option:selected" ).val() 
					console.log @delay
					@x=setInterval((=>
						$(".img_"+@imgId).attr("src",@filename + "?ts="+ new Date().getTime())
						console.log "Repeat for "+ @filename
					),@delay*1000)

			else if command == "stop"
				console.log "Stop Stream for "+ @imgId
				clearInterval(@x)
				@x=0
			else if command == "refresh"
				console.log "Refresh Stream for Camera "+ @imgId
				clearInterval(@x)
				@x=0
				$(".img_"+@imgId).attr("src",@filename + "?ts="+ new Date().getTime())
			@device.rest.streamCommand({command}, global: no)						
			
			return
		updateImage : (command) ->
			return
  
  # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
