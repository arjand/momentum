# Module goals:
	
# 	1.) responsible for setting and initializing all modules
# 	2.) attach handlers. This needs a global reset element -- calls reset on each one!
# 	3.) change frame, a and b elements here. An element that can be called from any class and then from the jquery elements
#	4.) loads in the animations automatically for the elements with animation module!

define ["jquery", "base_module", "animation", 'momentum_constants'], ($, baseModule, animation, momentum_constants) ->

	container = momentum_constants.HTML_CONTAINER
	# html elements!
	parent = $(container)

	parentElements = #base elemnets!

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
	elementData = #this is custom data that will over-write the modules!

		lab : #frame of reference from the laboratory
 
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

		red: #frame of reference of the red ball
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

		blue:#frame of reference from the blue ball
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

	modules = #create a base module for each and then send it callback functions etc for changing ...
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

		$(momentum_constants.PLAY_ALL_BUTTON).click () ->
			modules.lab.buttonAction()
			modules.red.buttonAction()
			modules.blue.buttonAction()
			modules.custom.buttonAction()			

		# clean this up with : http://stackoverflow.com/questions/7613100/issue-with-coffeescript-comprehensions-and-closures
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

		# when we update mass it should update accordingly in each element!
		listen = (colorClass) =>

			elements = parent.find(colorClass).find("input")

			# listen for changes on the sliders
			elements.change () ->

				value = $(this).attr "value"
				# for each module, need to call the change mass element!
					
				# set the ball mass / size

				setMass = for key, module of modules

					# get the proper element
					_element = if colorClass == ".blue_mass" then module.elements.b else module.elements.a
					_element.setMass parseInt value
		
				# set the slider positions!
				elements.each () ->

					$(this).attr "value", value
					label = $(this).siblings().children(".badge")
					label.text value + " kg"

		# initialize the listener closures for each type of mass element
		listen colorClass for colorClass in [".blue_mass", ".red_mass"]

	# initialize all the velocity elements for each frame that can be edited
	redVelocityChanges = (value) =>

		# this is responsible for changing the red velocity related elements across the elements
		modules.lab.elements.a.initializeVelocity value, modules.lab.elements.frame.getVelocity()
		
		modules.red.elements.frame.setVelocity value
		modules.red.elements.a.initializeVelocity value, modules.red.elements.frame.getVelocity()
		modules.red.elements.b.initializeVelocity modules.lab.elements.b.getVelocity(), modules.red.elements.frame.getVelocity()
		
		modules.blue.elements.a.initializeVelocity value, modules.blue.elements.frame.getVelocity()
		
		modules.custom.elements.a.initializeVelocity value, modules.custom.elements.frame.getVelocity()

	blueVelocityChanges = (value) =>
		#value = -1 * parseInt value
		
		modules.lab.elements.b.initializeVelocity value, modules.lab.elements.frame.getVelocity()
		
		modules.red.elements.b.initializeVelocity value, modules.red.elements.frame.getVelocity()
		
		modules.blue.elements.frame.setVelocity value
		modules.blue.elements.b.initializeVelocity value, modules.blue.elements.frame.getVelocity()
		modules.blue.elements.a.initializeVelocity modules.lab.elements.a.getVelocity(), modules.blue.elements.frame.getVelocity()
		
		modules.custom.elements.b.initializeVelocity value, modules.custom.elements.frame.getVelocity()

	do listeners = =>

		containers = parent.children(":nth-child(1), :nth-child(4)")


		parentElements.custom.find("input").click ->

			# subtract ten from value for offset hack because the input can not be negative
			value = parseInt $(this).attr("value") #- 10

			modules.custom.elements.frame.setVelocity value
			modules.custom.elements.a.initializeVelocity modules.lab.elements.a.config.velocity, value
			modules.custom.elements.b.initializeVelocity modules.lab.elements.b.config.velocity, value

		containers.find(".red_velocity > input").change ->

			redVelocityChanges $(this).attr "value"

		containers.find(".blue_velocity > input").change ->

			blueVelocityChanges $(this).attr "value"

