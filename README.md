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

You have to add your IP Camera device into your config.json based on these example schema ready to copy paste.

    {
      "id" : "ipcamera",
      "class": "IpCameraDevice",
      "name": "IP Camera",
      "filename": "snapshot.jpg",
      "cameraUrl": "[URL from your camera]",
      "username": "[optional username]",
      "password": "[optional password]",
      "width": 340,
      "height": 240,
      "leftURL": "",
      "rightURL": "",
      "upURL": "",
      "downURL": ""
    },
    


Description:
-------------

    id : should be your unique device id
    name : name of your device
    class : device class
    cameraUrl : url that direct to your http mjpeg server (should include all, include path to file)
    filename : location of local filename, will be represent inside of your img folder in pimatic-mobile-frontend/public/img
    width : max width of the snapshot that is being showed
    height : max height of the snapshot that is being showed
    leftURL : Url to be called to move camera to the left
    rightURL : Url to be called to move camera to the right
    upURL : Url to be called to move camera up
    downURL : Url to be called to move camera down
    
URLs to move camera:
---------------

Most simple IP cameras use HTTP requests to move the camera or activate / deactivate functions.
To obtain the Url that does a specific moving operation, you can use [Chrome Live HTTP Headers](https://chrome.google.com/webstore/detail/live-http-headers/iaiioopjkcekapmldfgbebdclcnpgnlo) plugin.

Then just trigger the action you want to see in the web interface of your camera. The HTTP headers will be recorded and you will be able to obtain the request Url, e.g. "http://192.168.XXX.XXX/decoder_control.cgi?loginuse=admin&loginpas=&command=4&onestep=1"

Version History
---------------
	1.2.0 : Added support to move a camera using HTTP requests
	1.1.2 : Minor modifications
    1.1.1 : Stable release of MJPEG Camera Snapshot 
    0.1.2 : First time release plugins
    
Roadmap
---------------
    1.1.*   : Support for MJPEG camera snapshot (revised)
    2.0.*   : Support for RTSP camera snapshot
    3.0.*   : support for motion and predicate handler, includes integration with Pimatic Rules, authentication, SSL Support

Notes:
-------------
    If you're upgrading from 0.1.* release, then you have to cleanup directory and reinstall again this plugin.
