# WebSocket proxy and JavaScript API for The Eye Tribe Tracker

## Run
1. `npm install`
2. `coffee server.coffee`

To run in SSL mode, simply add a key and cert to your top level directory. This can be done with the following command:

`openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem`

You may have to navigate to https://localhost:6556/eyetribe.min.js to override your browser's certificate trust guards on your first request to load the .js file.

## Example
```html
<script src="//localhost:6556/eyetribe.min.js"></script>
<script>
  EyeTribe.loop(function(frame) {
    console.log(frame);
  });
</script>
```

## Requirements
* [The Eye Tribe Tracker](https://theeyetribe.com/products/)
* [The Eye Tribe SDK](http://dev.theeyetribe.com/general/)
* [Node.js](http://nodejs.org/) 0.10 or later

## License

(The MIT License)
