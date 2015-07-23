$(document).on( "templateinit", (event) ->
  # define the item class
	class IpCameraDeviceItem extends pimatic.DeviceItem
		x=0	
		constructor: (templData, @device) ->
			uId = ""
			@id = @device.id
			@imgId = "img"+@device.id
			@name = @device.name
			@filename = "img/"+@device.config.filename
			@width = @device.config.width
			@height = @device.config.height
			console.log(@height + " " + @width)
			super(templData,@device)
			#console.log(this)
		afterRender : (elements) ->
			super(elements)
			@refreshButton = $(elements).find('[name=refreshButton]')
		refreshCommand : -> @sendCommand "refresh"
		sendCommand: (command) ->
			@updateImage(command)
			return
		updateImage : (command) ->
			@device.rest.sendCommand({command}, global: no)
			.done((data)=>
				x=setInterval((=>
					$("."+@imgId).attr("src",@filename + "?ts="+ new Date().getTime())
				),1000)
				$("."+@imgId)
					.on "load",()=>
						clearInterval(x)
						console.log("load success for "+@filename)
						return
					.on "error",()=> 
						console.log("still failed for loading "+@filename)
						return						
					# .attr("src",@filename + "?ts="+ new Date().getTime())
				return
			).fail(ajaxAlertFail)
			return		
    # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
