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
		afterRender : (elements) ->
			super(elements)
			@refreshButton = $(elements).find('[name=refreshButton]')
			return
		refreshCommand : -> @sendCommand "refresh"
		sendCommand: (command) ->
			@device.rest.sendCommand({command}, global: no)
				.done(ajaxShowToast)
				.fail(ajaxAlertFail)

    # register the item-class
	pimatic.templateClasses['ipcamera'] = IpCameraDeviceItem
)
