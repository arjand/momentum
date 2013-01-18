# MODULES
#coffee = require 'coffee-script'
jade = require "jade"#external module
fs = require "fs"


# SHORTCUTS
print = console.log

# GLOBAL VARIABLES
templateFile = "./layout.jade"
outputFile = "../index.html"
templateOptions =
	pretty: true
	filename: true

# JS files are compiled by yeoman and placed in temp directory
data = 
	header: require "../../temp/scripts/data/header.js"
	canvas: require "../../temp/scripts/data/canvas.js"

# compile function
compile = () ->

	# steps
	# 1.) compile header with options
	# 2.) compile canvas for each of the scripts
	# 3.) compile footer and overwrite
	# create header -- this clears the previous file if it exists and has content
	fs.readFile templateFile, "utf8", (err, rawTemplate) ->
		
		template = jade.compile rawTemplate, templateOptions

		html = template data

		fs.writeFile outputFile, html


# initialize program controllers below -- for watching etc
compile()

