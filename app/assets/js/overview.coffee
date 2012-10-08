
pebbles = require("pebbles")

window.services = new pebbles.service.ServiceSet(host: 'pebblestack.org');
window.services.use
  checkpoint: 1
  grove: 1

require("./shower")

window.__getProfile = () ->
  services.checkpoint.get("/identities/me").then (user) ->
    $('#profile').html("<img src='#{user.profile.image_url}'/> #{user.profile.name}")
