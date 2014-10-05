# WebSocket proxy and JavaScript API for The Eye Tribe Tracker

## Run
1. `npm install`
2. `coffee server.coffee`

## Example
```html
<script src="http://localhost:6556/eyetribe.min.js"></script>
<script>
  EyeTrie.loop(function(frame) {
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
