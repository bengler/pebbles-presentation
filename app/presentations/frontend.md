# Dealing with front-end in Pebbles

I am going to talk about

* Front end modules in the Pebbles universe
* Managing front-end dependencies with NPM + browserify
* Serving templates to the client
* Sprig - simple, lightweight dom components


# Client side libraries for Pebbles

So far we have knitted a couple of front end libraries

* pebbles.js
* tiramisu.js

We will keep on adding more when we see the need for it

# pebbles.js

The core module for dealing with pebbles and communicating with backend services.

# Example: Login with twitter
```js
// Example: fetching current user
var pebbles = require("pebbles");

// Initialize services with pebblestack.org as domain, using services checkpoint + grove
var services = new pebbles.service.ServiceSet({host: "pebblestack.org"}).use({
  checkpoint: 1,
  grove: 1
});

services.checkpoint.get("/identities/me").then(function(me) {
  if (me.identity == undefined) {
    alert("You are not logged in. Please login with twitter now.");
    services.checkpoint.login("twitter").then(function(me) {
      alert("Ahhh, much better "+me.profile.name+". Logging you out now");
    });
  }
});
```
<div data-sprig-component="code-example"></div>

# Example: Persisting a post using grove

```js
var post = new grove.GrovePost();
post.document.set("message", "Hello world")
post.save().then(function() {
  console.log("Post saved");
});
```

# tiramisu.js

Provides methods for uploading files and images to the Tiramisu pebble

# Code example
```js
var Uploader = require("tiramisu").ImageUploader;

var $form = $('#upload_form');
var $fileField = $form.find("input[type=file]");
var uploader = new Uploader($form);

$form.on('submit', function(e) {
  // Upload to tiramisu
  var request = uploader.upload($fileField[0], services.tiramisu.serviceUrl("/images/image:demo.example"));

  // Listen for progress events
  request.progress(function(progressData) {
    console.log("Progress: ", progressData);
  });

  // Upload complete, insert an <img tag displaying the uploaded image
  request.then(function(image) {
    console.log("Done: ", image);
    $form.append('<p><a href="'+image.metadata.original+'" target="_blank"><img src="'+image.metadata.versions[0].url+'"/></a>');
  });
  });
});
```

# Lets try it live
<iframe src="http://demo.dev/upload" height="300" width="100%"></iframe>

# Managing front-end dependencies
Oh, this library looks nice. Lemme grab it from Github and put it into my project directory


# Finn 23 feil
```
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N517874965/bundles/jquery.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/254056297/bundles/global.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/948196492/bundles/webcore.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/1159138092/bundles/modernizr.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N1348159000/bundles/iosfixes.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/1011511997/bundles/finn_tracking.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/559794582/bundle/user_dialog_box.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N322871202/bundles/eventhub.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N1478089889/bundles/underscore-latest.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N1699393888/bundles/trackinghub.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N213410675/bundles/userUnicaTracking.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N1929955293/bundles/jquery.ba-postmessage.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/1597501094/bundles/user_auth.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/1650761078/bundles/dialog.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N666756118/bundles/feedback.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/192924190/bundles/jquery_cookie.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/146659624/bundle/webads.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N1153788006/bundles/mustache.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/1764512641/bundles/tiles.manager.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/1500594189/bundles/user_templating.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N1452188905/bundle/mainfrontpage.js"></script>
<script type="text/javascript" src="http://cache.finn.no/jawr/js/N1692213884/bundles/finnboxtoggle.js"></script>
<script type="text/javascript" language="javascript" src="http://cache.finn.no/clientscript/spring.js"></script>
```

# Uhhh, dependencies anyone?
*           A modern web application typically require 10-20 different thirdparty javascript libraries (qualified guess)
*           This number increases rapidly as more heavy lifting are done in the client
*           These 10-20 libraries may depend on other libraries as well
*           Managing this manually is a slippery slope that leads to maintenance hell!


# NPM to the rescue!
* NPM is the Node.js Package Manager
* Comes with a online registry of modules and their dependendencies
*           State your application's dependencies in a file named
%mark.important
package.json
```json
"dependencies": {
  "tiramisu": "latest",
  "pebbles": "latest",
  "underscore": "latest",
  "jquery": "git://github.com/bjoerge/jquery-node.git"
}
```
* Now all of these dependencies will be available from your project using <strong>require("module")</strong>


# But isn't Node.js server side JavaScript?
 Yes! This means you can have your tests run on your CI server <strong>#WIN</strong>
%header
%h3
Let me rephrase that: How can you run JavaScript written for Node.js in the browser?
 Browserify magic to the rescue!


# Browserify

\=> https://github.com/substack/node-browserify
%br
<em>Browserify makes node-style require() work in the browser with a server-side build step, as if by magic!</em>

Magic means: scanning your source markdown for require()-statements and bundling all depended files/modules required into a single file


# Browserify + Ruby = Snowball

QUICK DEMO


# Extra goodies
*           Snowball supports Jade out of the box
*           CoffeeScript just works too (quick demo)


# Rendering templates server side?
*


# Browserify + Ruby = Snowball

QUICK DEMO


# The end


# Questions?

```