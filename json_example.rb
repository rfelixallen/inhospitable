require 'rubygems'
require 'json'

json = File.read('input.json')
obj = JSON.parse(json)

puts obj["title"]
puts obj["url"]