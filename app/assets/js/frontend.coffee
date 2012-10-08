require("./shower")

window.$ = $ = require("jquery")
window.pebbles = pebbles = require("pebbles")

services = new pebbles.service.ServiceSet({host: "pebblestack.org"}).use({
  checkpoint: 1
});
services.checkpoint.get("/logout");

Sprig = require("sprig");

Sprig.add 'code-example', (el, opts)->
  $el = $(el)
  code = $el.prev('.highlight').text().split("\n")[2...-2].join("\n")
  $runBtn = $('<button class="btn btn-info">Run</button>')
  $runBtn.on 'click', ->
    eval(code)
  $runBtn.insertBefore($el.prev('.highlight'))

$ ->
  Sprig.load($("body"))