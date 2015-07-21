$(document).on( "templateinit", (event) ->
 
  # define the item class
	class IpCameraDeviceItem extends pimatic.DeviceItem
		x=0	
		constructor: (templData, @device) ->
			@id = @device.id
			@imgId = "img"+@device.id
			@name = @device.name
			@filename = "img/"+@device.config.filename
			super(templData,@device)
			console.log(this)
		afterRender : (elements) ->
			super(elements)
			@refreshButton = $(elements).find('[name=refreshButton]')
			@device.rest.sendCommand({command:"refresh"}, global: no)
			return
		refreshCommand : -> @sendCommand "refresh"
		sendCommand: (command) ->
			@device.rest.sendCommand({command}, global: no)
			#console.log(this)
			.done(()=>
				x=setInterval((=>
					$("#"+@imgId).attr("src",@filename + "?ts="+ new Date().getTime())
					#console.log("update terus")
				),1000)
				$("#"+@imgId)
					.on "load",()-> 
						clearInterval(x)
						console.log("load success for "+@filename)
					.on "error",()-> 
						console.log("still failed for loading "+@filename)
						return						
					.attr("src",@filename + "?ts="+ new Date().getTime())
				return
			).fail(ajaxAlertFail)
			return
		
    # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
