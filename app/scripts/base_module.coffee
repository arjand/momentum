# A BaseModule contains the logic for one particular animation (frame
# of reference). Each base module contains 2 balls and various controls
# for modifying the animation and reporting data to the user.

define ['jquery', 'paper', 'ball', 'frame', 'momentum_constants'], ($, paper, ball, frame, momentum_const) ->

	class BaseModule
				
		constructor : (@container, @options) -> #send in options -- ie: height / width

			# initialize paperjs library
			@paper = new paper.PaperScope()
			@canvas = @container.children("canvas")[0]
			@paper = new paper.PaperScope()
			@tool = new @paper.Tool()
			@paper.setup @canvas
			@view = new @paper.View(@canvas)

			@view.draw = () ->
				# should not be re-implemented

			# element data initializing 
			@elements =
				a : new ball @paper, @container.find(".red_velocity"), @container.find(".red_mass"),@options.a
				b : new ball @paper, @container.find(".blue_velocity"), @container.find(".blue_mass"), @options.b
				frame : new frame @paper, @container.find(".frame_velocity"), @options.frame

			@imgElement = @container.find("img")

			# paper view
			@playing = false
			@numCollisions = 0
			@paper.view.draw()	

		isPlaying : () ->
			return @playing

		isFinished : () ->
			return not @playing and @numCollisions > 0

		# adjusts the image of the play button 
		adjustPlayButton: () =>			
			if @isFinished()
				src = "refresh"
			else if @isPlaying()
				src = "pause"
			else 
				src = "play"			
			newImage = @imgElement.attr("src").replace(/(images\/.*)play|pause|refresh(\.png)$/i, "$1#{src}$2" )					
			@imgElement.attr("src", newImage)

		# action to take when the play button is pressed
		buttonAction : () ->
			if @isFinished()
				@reset()
			else
				@play()

			@adjustPlayButton()

		reset : () ->
			for name,ball of @elements
				if name != 'frame'
					ball.positionReset()
					ball.velocityReset()			

			@numCollisions = 0 

		play : () =>
			# initialize references to the proper objects
			left = @elements.a
			right = @elements.b
			frame = @elements.frame

			# initialize our running variables			
			rightRunning = true
			leftRunning = true			

			# run is executed when the animation is running
			run = () =>
				if !@playing
					return 

				# cache velocities etc for quick local access
				lv = left.getVelocity()
				lm = left.getMass()

				rv = right.getVelocity()
				rm = right.getMass()

				fv = frame.getVelocity()

				# constraints on the elements triggering an end of completion for the animation
				maxLeft = @paper.view.size.width * 0.05 
				maxRight = @paper.view.size.width * 0.95 

				# validate both red and blue balls
				do leftStatus = () =>
					reset = () =>
						leftRunning = false
						
					move = () =>						
						delta = lv # maximum amount of change for this element
						current = left.element.position.x 
						collisionBound = right.element.position.x - right.radius #right ball's collision element
						
						left.element.position.x += delta


					if leftRunning or @numCollisions > 0

						if lv == 0 or lm == 0   or @numCollisions > 1 #or (lv + fv) == 0
							do reset
								
						else if parseInt(left.element.position.x) > maxRight or parseInt(left.element.position.x) < maxLeft
							do reset

						else
							do move
						
						@paper.view.draw()

				do rightStatus = () =>
					reset = () =>
						rightRunning = false				

					move = () =>
						maxDelta = right.getVelocity() 
						current = right.element.position.x - right.radius
						collisionBound = left.element.position.x + left.radius

						right.element.position.x += maxDelta							

					if rightRunning or @numCollisions > 0
					
						if rv == 0 or rm == 0  or @numCollisions > 1 #or rv + fv == 0
							do reset

						else if right.element.position.x < maxLeft or right.element.position.x > maxRight
							do reset

						else
							do move

						# refresh the scene if still running
						@paper.view.draw()

				# Physics described on wikipedia: http://en.wikipedia.org/wiki/Elastic_collision
				collisionResponse = () =>
					lm = do left.getMass
					rm = do right.getMass

					lfv = ((lv * (lm - rm)) + (2 * rm * rv)) / (lm + rm)

					rfv = ((rv * (rm - lm)) + (2* lm * lv)) / (lm + rm)

					left.setVelocity lfv
					right.setVelocity rfv

					# after a collision both balls are running/moving
					rightRunning = true
					leftRunning = true

				# check collision status and respond if necessary
				do collisionStatus = () =>					

					# collision hasn't happened ... check values etc
					lbRightSide = left.element.position.x + left.radius
					rbLeftSide = right.element.position.x - right.radius
					
					if (rbLeftSide <= lbRightSide) and (@numCollisions <=2)						
						@paper.view.draw()

						# handle the collision
						do collisionResponse # responsible for controlling the reset values etc after the collision
						@numCollisions += 1				
						

				# re-evaluate the animation status. Restart if necessary
				if leftRunning or rightRunning
					return setTimeout run, 10

				else 						
					@playing = false
					$(momentum_const.HTML_CONTAINER).trigger('CNmomentumAnimationDone', this);					
					@paper.view.draw()
					
			# END RUN METHOD

			# handle the play call!
			if not @playing
				@playing = true
				do run #run the element
			else
				@playing = false  #pause
		# END PLAY METHOD

		







