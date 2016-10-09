# #my-plugin configuration options
# Declare your config option for your plugin here. 
module.exports = {
	title: "Ip Camera"
	IpCameraDevice :{
		title: "Plugin Properties"
		type: "object"
		extensions: ["xLink"]
		properties:
			username:
				description: "User name for the access"
				type: "string"
				default: ""
			password:
				description: "password for the access"
				type: "string"
				default: ""
			cameraUrl:
				description: "URL of IP Camera"
				type: "string"
			filename:
				description: "File name of the output"
				type: "string"             
			width:
				description: "Width of the Image"
				type: "number"				
				default : 340				
			height:
				description: "Height of the Image"
				type: "number"
				default : 240
			leftURL:
				description: "CURL URL to move camera left"
				type: "string"
				default: ""
			rightURL:
				description: "CURL URL to move camera right"
				type: "string"
				default: ""
			upURL:
				description: "CURL URL to move camera up"
				type: "string"
				default: ""
			downURL:
				description: "CURL URL to move camera down"
				type: "string"
				default: ""
	}
}
