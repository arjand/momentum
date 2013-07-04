# Base Ball Module

# responsible for handling the ball before animation
# will hold the ball and its attributes etc
# when the animation is run, we will actually use it on the element in the base_module
# after the animation is run, we reset completely!
# on click we need to change the value of the velocity -- this can be later functionality

define ["paper"], (paper) ->

	class Ball

		constructor : (@paper, @velocityContainer, @massContainer, options) ->
			@massLabel = massContainer.find "span:nth-child(2)"
			@velocityLabel = velocityContainer.find "span:nth-child(2)"
			@input = velocityContainer.find "input"

			@config =				
				ballSizeChange: false
				radiusFactor: 7
				verticalOffset: 40
				horizontalOffset: @paper.view.size.width * 0.25
				left : true
				maxHeight : @paper.view.size.height
				maxWidth : @paper.view.size.width

			# for each element, set the global config for this
			@config.mass = options.mass
			@config.velocity = options.velocity

			@config.left = options.left
			@config.color = options.color
			@velocity = options.velocity
			@config.mass = options.mass
			@mass = options.mass
			@radius = @mass * @config.radiusFactor

			# initialze the element
			@init()
		# end constructor function

		init : () =>

			# initialize x / y functions!
			_x = if @config.left then @config.horizontalOffset + @radius else @config.maxWidth - @config.horizontalOffset - @radius
			_y = @config.maxHeight - @config.verticalOffset

			# initialize the original element
			@original = new @paper.Point _x, _y

			# can make this a layer in the future! -- to incorporate animations in the objects for more excitement!
			@circle = new @paper.Path.Circle @original, @radius
			@text = new @paper.PointText new @paper.Point @original.x, @original.y + 4
			@element = new @paper.Layer([@circle, @text])

			# initialize the ball style!
			@circle.fillColor = @config.color
			@circle.smooth()

			# initialize text
			@text.justification = "center"
			@text.fillColor = "white"
			@setText @getVelocity()

			# draw the element
			@paper.view.draw()

		setText : (velocity) =>			
			@text.content = Math.round(velocity*10)/10 + "m/s"

		attrReset : (oldRadius) =>		
			# reset the radius of the circle
			@circle.scale @radius / oldRadius

			# recreate the coordinates for this item
			@original.x = if @config.left then @config.horizontalOffset + @radius else @config.maxWidth - @config.horizontalOffset - @radius
			@original.y = @config.maxHeight - @config.verticalOffset

			# actually move the elmeent
			@element.position.x = @original.x
			@element.position.y = @original.y

			# update the view
			@paper.view.draw()
		
		positionReset : () =>
			# useful when we just are finished running the animation
			@element.position.x = @original.x
			@element.position.y = @original.y

			@paper.view.draw()
		
		velocityReset : () =>
			@setVelocity @config.velocity

		setVelocity : (velocity) => 
			@setText velocity
			@velocity = velocity

			@paper.view.draw()

		initializeVelocity : (velocity, frameVelocity) =>
			@config.velocity = parseInt(velocity) - frameVelocity
			@velocityReset()

			# set up the velocities so that they are displayed properly			
			@velocityLabel.text @velocity + " m/s"
			@input.attr "value", @velocity 

			@paper.view.draw()			
		
		setMass : (mass) =>
			@config.mass = mass
			@mass = mass
			oldRadius = @radius

			if @config.ballSizeChange
				@radius = @mass * @config.radiusFactor
			
			@attrReset oldRadius

			@massLabel.text @mass + " kg"
		
		getVelocity : () =>			
			return @velocity
		
		getMass : () =>
			return @mass

