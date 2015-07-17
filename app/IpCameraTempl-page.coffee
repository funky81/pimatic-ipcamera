$(document).on( "templateinit", (event) ->
 
  # define the item class
	class IpCameraDeviceItem extends pimatic.DeviceItem
		constructor: (templData, @device) ->
			@imagePath="ipcamera/image/img.png"
			@message = @device.config.message
			@id = @device.id
			super(templData,@device)
		#	console.log(this)
		#afterRender: (elements) -> 
		#	super(elements)
		onButtonPress: ->
			$.get("/api/device/#{@id}/actionToCall").fail(ajaxAlertFail)
      
  # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
