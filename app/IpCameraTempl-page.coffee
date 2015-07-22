$(document).on( "templateinit", (event) ->
	arrId=[]
  # define the item class
	class IpCameraDeviceItem extends pimatic.DeviceItem
		x=0	
		constructor: (templData, @device) ->
			uId = ""#snew Date().getTime()
			@id = @device.id + uId
			@imgId = "img"+@device.id+ uId
			@name = @device.name
			@filename = "img/"+@device.config.filename
			super(templData,@device)
			#console.log(this)
		afterRender : (elements) ->
			super(elements)
			@refreshButton = $(elements).find('[name=refreshButton]')
			if @id not in arrId
				arrId.push @id
				console.log arrId
				@device.rest.sendCommand({command:"refresh"}, global: no)
			return
		refreshCommand : -> @sendCommand "refresh"
		sendCommand: (command) ->
			@updateImage(command)
			return
		updateImage : (command) ->
			@device.rest.sendCommand({command}, global: no)
			.done((data)=>
				console.log(data)
				x=setInterval((=>
					$("."+@imgId).attr("src",@filename + "?ts="+ new Date().getTime())
					console.log("update terus "+x)
				),1000)
				$("."+@imgId)
					.on "load",()=>
						clearInterval(x)
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
