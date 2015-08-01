$(document).on( "templateinit", (event) ->
  # define the item class
	class IpCameraDeviceItem extends pimatic.DeviceItem
		x=0	
		constructor: (templData, @device) ->
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
		streamCommand: (command) ->
			if command == "stop"
				$("."+@imgId).attr('src','/img/'+@id+".jpg?t="+new Date().getTime())
			else
				$("."+@imgId).attr('src','/stream/'+@id)
			@device.rest.streamCommand({command}, global: no)						
			return
		updateImage : (command) ->
			return
  
  # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
