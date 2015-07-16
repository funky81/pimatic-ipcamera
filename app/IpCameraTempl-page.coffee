$(document).on( "templateinit", (event) ->
 
  # define the item class
	class IpCameraTemplDeviceItem extends pimatic.DeviceItem
		constructor: (templData, @device) ->
			#console.log(this)
			#console.log(@device.message)
			@message = @device.config.message
			@id = @device.id
			super(templData,@device)
    #   # Do something, after create: console.log(this)
			console.log(this)
		afterRender: (elements) -> 
			super(elements)
      # Do something after the html-element was added
    #onButtonPress: ->
    #  $.get("/api/device/#{@deviceId}/actionToCall").fail(ajaxAlertFail)
      
  # register the item-class
	pimatic.templateClasses['IpCameraTempl'] = IpCameraTemplDeviceItem
)
