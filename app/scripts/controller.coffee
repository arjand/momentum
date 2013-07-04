# The controller acts as the manager of the animation, controlling
# the various frames of reference in the animation. 
# 
# Setup containers and HTML canvas elements
# Load default data into each frame
# Handle the play all button
# Attach listeners for handling user input

define ["jquery", "base_module", "animation", 'momentum_constants'], ($, baseModule, animation, momentum_constants) ->

	container = momentum_constants.HTML_CONTAINER
	# html elements
	parent = $(container)

	# base elemnets
	parentElements = 
		"lab" : $(container + ' > div:nth-child(1) > .momentum-content') 
		"red" : $(container + ' > div:nth-child(2) > .momentum-content') 
		"blue" : $(container + ' > div:nth-child(3) > .momentum-content')
		"custom" : $(container + ' > div:nth-child(4) > .momentum-content')

	# initialize an object with all canvases pre-selected
	canvasElements = 
		"lab" : parentElements.lab.children "canvas"
		"red" : parentElements.red.children "canvas"
		"blue" : parentElements.blue.children "canvas"
		"custom" : parentElements.custom.children "canvas"

	# element data is responsible for each module's initial data. 
	elementData = 
		lab : # frame of reference from the laboratory 
			name: "lab"
			a : 
				velocity: 5
				mass: 3
				color: "#b94a48"
				left: true
			b :
				velocity: -1
				mass: 5
				color: "#3A87AD"
				left: false
			frame: 
				velocity: 0

		red: # frame of reference of the red ball
			name : "red"
			a :
				mass: 3
				velocity: 0
				left: true
				color: "#b94a48"
			b:
				mass: 5
				velocity: -6
				color: "#3A87AD"
				left: false
			frame:
				velocity: 5

		blue: # frame of reference from the blue ball
			name: "blue"
			a:
				mass: 3
				velocity: 6
				color: "#b94a48"
				left: true
			b:
				mass: 5
				velocity: 0
				color: "#3A87AD"
				left: false
			frame:
				velocity: -1

		custom: #custom frame of reference
			name: "custom"
			a:
				mass: 3
				velocity: 5
				color: "#b94a48"
				left: true
			b:
				mass: 5
				velocity: -1
				color: "#3A87AD"
				left: false
			frame:
				velocity: 0

	# create a base module for each frame 
	modules = 
		lab : new baseModule parentElements.lab, elementData.lab
		red : new baseModule parentElements.red, elementData.red
		blue : new baseModule parentElements.blue, elementData.blue
		custom : new baseModule parentElements.custom, elementData.custom

	# respond to event fired by basemodule when animation is finished
	$(container).on('CNmomentumAnimationDone', (event, element) ->		 
		for name,module  of modules
			module.adjustPlayButton()
	);

	do playListener = () ->
		# when play all button is clicked, simulate clicking each frame's play buton
		$(momentum_constants.PLAY_ALL_BUTTON).click () ->
			for name,module of modules
				module.buttonAction()						
		
		parentElements.lab.find(momentum_constants.PLAY_BUTTON).click () ->
			modules.lab.buttonAction()			

		parentElements.red.find(momentum_constants.PLAY_BUTTON).click () ->
			modules.red.buttonAction()			

		parentElements.blue.find(momentum_constants.PLAY_BUTTON).click () ->
			modules.blue.buttonAction()			
		
		parentElements.custom.find(momentum_constants.PLAY_BUTTON).click () ->
			modules.custom.buttonAction()		
				

	# initialize the elements
	do massListener = () ->
		# when we update mass it should update accordingly in each element
		listen = (colorClass) =>
			elements = parent.find(colorClass).find("input")

			# listen for changes on the sliders
			elements.change () ->
				value = $(this).attr "value"		
					
				# set the ball mass / size
				# for each module, need to call the change mass element
				setMass = for key, module of modules

					# get the proper element
					_element = if colorClass == ".blue_mass" then module.elements.b else module.elements.a
					_element.setMass parseInt value
		
				# set the slider positions
				elements.each () ->
					$(this).attr "value", value
					label = $(this).siblings().children(".badge")
					label.text value + " kg"

		# initialize the listener closures for each type of mass element
		listen colorClass for colorClass in [".blue_mass", ".red_mass"]

	# When the velocity of the red ball is changed, update the velocity of 
	# the red ball in each frame. Also ensure the red frame gets updated properly.
	redVelocityChanges = (value) =>		
		modules.lab.elements.a.initializeVelocity value, modules.lab.elements.frame.getVelocity()
		
		modules.red.elements.frame.setVelocity value
		modules.red.elements.a.initializeVelocity value, modules.red.elements.frame.getVelocity()
		modules.red.elements.b.initializeVelocity modules.lab.elements.b.getVelocity(), modules.red.elements.frame.getVelocity()
		
		modules.blue.elements.a.initializeVelocity value, modules.blue.elements.frame.getVelocity()
		
		modules.custom.elements.a.initializeVelocity value, modules.custom.elements.frame.getVelocity()

	# When the velocity of the blue ball is changed, update the velocity of 
	# the red ball in each frame. Also ensure the red frame gets updated properly.
	blueVelocityChanges = (value) =>			
		modules.lab.elements.b.initializeVelocity value, modules.lab.elements.frame.getVelocity()
		
		modules.red.elements.b.initializeVelocity value, modules.red.elements.frame.getVelocity()
		
		modules.blue.elements.frame.setVelocity value
		modules.blue.elements.b.initializeVelocity value, modules.blue.elements.frame.getVelocity()
		modules.blue.elements.a.initializeVelocity modules.lab.elements.a.getVelocity(), modules.blue.elements.frame.getVelocity()
		
		modules.custom.elements.b.initializeVelocity value, modules.custom.elements.frame.getVelocity()

	# add listeners
	do listeners = =>
		containers = parent.children(":nth-child(1), :nth-child(4)")

		# Handle changes to the frame velocity in the custom frame
		parentElements.custom.find("input").click ->			
			value = parseInt $(this).attr("value") 

			modules.custom.elements.frame.setVelocity value
			modules.custom.elements.a.initializeVelocity modules.lab.elements.a.config.velocity, value
			modules.custom.elements.b.initializeVelocity modules.lab.elements.b.config.velocity, value

		containers.find(".red_velocity > input").change ->
			redVelocityChanges $(this).attr "value"

		containers.find(".blue_velocity > input").change ->
			blueVelocityChanges $(this).attr "value"

