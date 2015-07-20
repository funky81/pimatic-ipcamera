$(document).on( "templateinit", (event) ->
 
  # define the item class
	class IpCameraDeviceItem extends pimatic.DeviceItem
		constructor: (templData, @device) ->
			@id = @device.id
			@imgId = "img"+@device.id
			@name = @device.name
			@filename = "img/"+@device.config.filename
			super(templData,@device)
			console.log(this)
		#afterRender : (elements) ->
		#	super

    # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
