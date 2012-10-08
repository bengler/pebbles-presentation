# Pebbles Overview

# But it gets hairy when …
```js
var test = hello();
var test = hello();
var test = hello();
var test = hello();
```

```
hei
```

```haml

.slide#Cover
  %div
    %section
      %header
        %h2 Dealing with front-end in Pebbles
      %p
        I am going to talk about
        %ul
          %li Front end modules in the Pebbles universe
          %li Managing front-end dependencies with NPM + browserify
          %li Serving templates to the client
          %li Front-end libraries for pebbles: pebbles.js, grove.js and tiramisu.js
          %li Sprig - simple, lightweight dom components

.slide#client-side-pebbles
  %div
    %section
      %header
        %h2 Client side libraries for Pebbles

      %p So far we have knitted the following front end libraries
      %ul
        %li
          pebbles.js
        %li
          tiramisu.js
        %li
          grove.js

      %p All are open source, available at http://github.com/bengler

.slide#pebbles-js
  %div
    %section
      :markdown
        # Hello

        ```js
        var test = hello();
        ```


.slide#grove-js
  %div
    %section
      %header
        %h2 grove.js

      %p Provides convenience methods for working with grove posts

      :markdown
        Todo

.slide#tiramisu-js
  %div
    %section
      %header
        %h2 tiramisu.js
      %p
        Provides methods for uploading files and images to the tiramisu service
        %div.markdown-medium
          :markdown
            var Uploader = require("tiramisu").ImageUploader;

            var $form = $('#my_upload_form');
            $fileField = $form.find("input[type=file]");

            var uploader = new Uploader($form);

            $form.find('button.upload').on('click', function() {
              var request = uploader.upload($fileField[0], services.tiramisu.serviceUrl("/images/image:demo.example"));

              request.progress(function(event) {
                console.log("Progress: ", event);
              }):

              request.then(function(image) {
                $('body').append('<img src="'+image.metadata.versions[0].url+'"/>");
              });
            });

.slide#First
  %div
    %section
      %header
        %h2
          How do you manage front end dependencies?
      %blockquote Oh, this library looks nice. Lemme grab it from Github and put it into my project directory

.slide#Second
  %div
    %section
      Finn 23 feil
      %div.markdown-small
        :markdown
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

.slide#Third
  %div
    %section
      %header
        %h2 Uhhh, dependencies anyone?
      %ul
        %li
          A modern web application typically require 10-20 different thirdparty javascript libraries (qualified guess)
        %li
          This number increases rapidly as more heavy lifting are done in the client
        %li
          These 10-20 libraries may depend on other libraries as well
        %li
          Managing this manually is a slippery slope that leads to maintenance hell!

.slide#Fourth
  %div
    %section
      %header
        %h2 NPM to the rescue!
      %ul
        %li NPM is the Node.js Package Manager
        %li Comes with a online registry of modules and their dependendencies
        %li
          State your application's dependencies in a file named
          %mark.important
            package.json
          %div.markdown-medium
            :markdown
              "dependencies": {
                "tiramisu": "latest",
                "pebbles": "latest",
                "underscore": "latest",
                "jquery": "git://github.com/bjoerge/jquery-node.git"
              }
        %li Now all of these dependencies will be available from your project using <strong>require("module")</strong>

.slide#Fifth
  %div
    %section
      %header
        %h2 But isn't Node.js server side JavaScript?
      %p Yes! This means you can have your tests run on your CI server <strong>#WIN</strong>
      %header
        %h3
          Let me rephrase that: How can you run JavaScript written for Node.js in the browser?
      %p Browserify magic to the rescue!

.slide#Sixth
  %div
    %section
      %header
        %h2 Browserify
      %p
        \=> https://github.com/substack/node-browserify
        %br
        <em>Browserify makes node-style require() work in the browser with a server-side build step, as if by magic!</em>
      %p
        Magic means: scanning your source markdown for require()-statements and bundling all depended files/modules required into a single file

.slide#Seventh
  %div
    %section
      %header
        %h2 Browserify + Ruby = Snowball
      %p
        QUICK DEMO

.slide#Eighth
  %div
    %section
      %header
        %h2 Extra goodies
      %ul
        %li
          Snowball supports Jade out of the box
        %li
          CoffeeScript just works too (quick demo)

.slide#Nineth
  %div
    %section
      %header
        %h2 Rendering templates server side?
      %ul
        %li


.slide#Tenth
  %div
    %section
      %header
        %h2 Browserify + Ruby = Snowball
      %p
        QUICK DEMO

.slide#Fifteenth
  %div
    %section
      %header
        %h2 The end
      %p
      %header
        %h2 Questions?

```