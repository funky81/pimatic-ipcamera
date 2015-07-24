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
			@width = @device.config.width  ? @device.configDefaults.width
			@height = @device.config.height ? @device.configDefaults.height 
			super(templData,@device)
		afterRender : (elements) ->
			super(elements)
			@refreshButton = $(elements).find('[name=refreshButton]')
		refreshCommand : -> @sendCommand "refresh"
		sendCommand: (command) ->
			@updateImage(command)
			return
		updateImage : (command) ->
#			$.ajax({url: 'api/device/'+@id+'/sendCommand?command=refresh',async:false})
#			.done(()=>
#				$("."+@imgId).attr("src",@filename + "?ts="+ new Date().getTime())
#			)
#			return

#			socket = pimatic.socket
#			
			@device.rest.sendCommand({command}, global: no)
			.done((data)=>
				x=setInterval((=>
					$("."+@imgId).attr("src",@filename + "?ts="+ new Date().getTime())
					pimatic.loading "deletedevice", "show", text: __('Saving')
					console.log "test"
				),1000)
				$("."+@imgId)
					.on "load",()=>
						clearInterval(x)
						pimatic.loading "deletedevice", "hide"
						console.log("load success for "+@filename)
						return
					.on "error",()=> 
						console.log("still failed for loading "+@filename)
						return						
					.attr("src",@filename + "?ts="+ new Date().getTime())
				return
			).fail(ajaxAlertFail)


			return		
    # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
