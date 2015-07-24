pimatic-ipcamera
=======================

This is [Pimatic](http://pimatic.org) plugin to view IP Camera either [Motion JPEG](https://en.wikipedia.org/wiki/Motion_JPEG) format or [Real Time Streaming Protocol](https://id.wikipedia.org/wiki/Real_Time_Streaming_Protocol) format in snapshot form.

You can develop, edit and contribute for this plugin by forking this plugin in [github](https://github.com/funky81/pimatic-ip-camera)

Installation
-------------
Add this plugin by go to Pimatic apps Plugin menu

Add the plugin to the plugin section:

    {
      "plugin": "ipcamera"
    },

Configuration
-------------

then you have to add your devices into your config.json based on these schema

    {
      "id": "ID of your camera",
      "name": "Name of your camera",
      "class": "IpCameraDevice",
      "cameraUrl": "URL from your camera",
      "filename": "Filename",
      "refresh": Snapshot refresh
    },

Description:
-------------

    id : should be your unique device id
    name : name of your device
    class : device class
    cameraUrl : url that direct to your http mjpeg server (should include all, include path to file)
    filename : location of local filename, will be represent inside of your img folder in pimatic-mobile-frontend/public/img
    refresh : time taken in seconds!

Compatibility
-------------

Different cameraUrl types

Supported:

    http://[host]:[port]/[script.extension]?user=[user]&pwd=[password]

Not supported yet or unknown:

    http://[host]:[port]/[directory]/[script.extension]?-usr=[user]&-pwd=[password] 
    http://[user]:[password]@[host]:[port]/[script.extension]
    
for better list check here http://www.ispyconnect.com
for example
    Panasonic BL-C1 : http://www.ispyconnect.com/man.aspx?n=panasonic (currently only support MJPEG in connection type column)

Version History
---------------
    1.0.0 : Stable release
    0.1.2 : First time release plugins
    
Roadmap
---------------
    1.0.*   : Support for MJPEG camera snapshot
    2.0.*   : Support for RTSP camera snapshot
    3.0.*   : support for motion and predicate handler, includes integration with Pimatic Rules, authentication, SSL Support
