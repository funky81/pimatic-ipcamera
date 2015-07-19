$(document).on( "templateinit", (event) ->
 
  # define the item class
	class IpCameraDeviceItem extends pimatic.DeviceItem
		constructor: (templData, @device) ->
			@id = @device.id
			@name = @device.name
			@filename = "img/"+@device.config.filename
			super(templData,@device)
			console.log(this)
		#afterRender: (elements) -> 
		#	super(elements)
      
  # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
