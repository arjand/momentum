# The Frame represents the visual box containing a particular
# frame of reference. For example, one page may contain 4 
# frames. 

define ["paper"], (paper) ->

	class Frame

		constructor : (@paper, @container, options) ->
			@config = []

			for key, value of options

				@config[key] = value

			@tag = @container.find "span:nth-child(2)"
			@input = @container.find "input"

 
		getVelocity : () =>
			return @config.velocity

		setVelocity : (velocity) =>
			@config.velocity = parseInt velocity
			@tag.html @config.velocity + " m/ss"
