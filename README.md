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
      "refresh": "10",
      "width": 340,
      "height": 240
    },

Description:
-------------

    id : should be your unique device id
    name : name of your device
    class : device class
    cameraUrl : url that direct to your http mjpeg server (should include all, include path to file)
    filename : location of local filename, will be represent inside of your img folder in pimatic-mobile-frontend/public/img
    refresh : time taken in seconds
    width : max width of the snapshot that is being showed
    Height : max height of the snapshot that is being showed

Version History
---------------
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
