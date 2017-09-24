require 'open-uri'
require 'json'

response = open('https://maps.googleapis.com/maps/api/place/textsearch/json?query=Tourist+spots+in+Calicut&key=AIzaSyCQxwpFj_2pTM3i3Ljejzf9KMg8AfwrNTw').read

response = JSON.parse(response)
puts response["results"][0]["name"]
