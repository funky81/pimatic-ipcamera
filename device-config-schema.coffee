# #my-plugin configuration options
# Declare your config option for your plugin here. 
module.exports = {
	title: "Ip Camera"
	IpCameraDevice :{
		title: "Plugin Properties"
		type: "object"
		extensions: ["xLink"]
		properties:
			cameraUrl:
				description: "URL of IP Camera"
				type: "string"
			filename:
				description: "File name of the output"
				type: "string"             
			refresh:
				description: "Time to refresh screenshot"
				type: "number"
			width:
				description: "Width of the Image"
				type: "number"				
			height:
				description: "Height of the Image"
				type: "number"				
	}
}
