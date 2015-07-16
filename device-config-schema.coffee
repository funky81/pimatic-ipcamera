# #my-plugin configuration options
# Declare your config option for your plugin here. 
module.exports = {
  title: "Ip Camera"
  IpCamera :{
    title: "Plugin Properties"
    type: "object"
    extensions: ["xLink"]
    properties:
      message:  
          description: "Text to be displayed"
          format: "string"    
  }
}
