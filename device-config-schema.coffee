# #my-plugin configuration options
# Declare your config option for your plugin here. 
module.exports = {
	title: "Ip Camera"
	IpCameraDevice :{
		title: "Plugin Properties"
		type: "object"
		extensions: ["xLink"]
		properties:
			message:  
				description: "Text to be displayed"
				format: "string"   
			filename:
				description: "File name of the output"
				type: "string"             
	}
}
