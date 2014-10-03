# WebSocket proxy and javascript API for The Eye Tribe Tracker

## Run
1. `npm install`
2. `coffee server.coffee`

## Example
```html
<script src="http://localhost:6556/eyetribe.js"></script>
<script>
  EyeTrie.loop(function(frame) {
    console.log(frame);
  });
</script>
```

## Requirements
* [The Eye Tribe](https://theeyetribe.com/products/)
* [The Eye Tribe SDK](http://dev.theeyetribe.com/general/)
* [Node.js](http://nodejs.org/) 0.10 or later

## License

(The MIT License)
