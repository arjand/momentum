module.exports = {

	1 : 
		header: "Laboratory Frame of Reference"
		frame: "laboratory"
		controls : 
			frameVelocity:
				class: "frame_velocity"
				editable: false
				type: "slider"
				min: 0
				value: 0
				max: 10
				name: "Frame Velocity"
				label: "m/s"

			redMass:
				class: "red_mass"
				editable: true
				type: "slider"
				min: 1
				value: 3
				max: 10
				name: "Red Mass"
				label: "kg"

			blueMass:
				class: "blue_mass"
				editable: true
				type: "slider"
				min: 1
				value: 5
				max: 10
				name: "Blue Mass"
				label: "kg"

			redVelocity:
				class: "red_velocity"
				editable: true
				type: "slider"
				min: 0
				value: 5
				max: 10
				name: "Red Velocity"
				label : "m/s"

			blueVelocity: 
				class: "blue_velocity"
				editable: true
				type: "slider"
				min: -10
				value: -1
				max: 0
				name: "Blue Velocity"
				label : "m/s"

	2 : 
		header: "Red Ball Frame of Reference"
		frame: "red_ball"
		controls : 

			redVelocity:
				class: "red_velocity"
				editable: false
				type: "slider"
				min: 0
				value: 0
				max: 10
				name: "Red Velocity"
				label : "m/s"

			blueVelocity: 
				class: "blue_velocity"
				editable: false
				type: "slider"
				min: -0
				value: -6
				max: 10
				name: "Blue Velocity"
				label : "m/s"

			redMass:
				class: "red_mass"
				editable: false
				type: "slider"
				min: 1
				value: 3
				max: 10
				name: "Red Mass"
				label: "kg"

			blueMass:
				class: "blue_mass"
				editable: false
				type: "slider"
				min: 1
				value: 5
				max: 10
				name: "Blue Mass"
				label: "kg"

			frameVelocity:
				class: "frame_velocity"
				editable: false
				type: "slider"
				min: 0
				value: 5
				max: 10
				name: "Frame Velocity"
				label: "m/s"

	3:
		header: "Blue Ball Frame of Reference"
		frame : "blue_ball"
		controls : 

			redVelocity:
				class: "red_velocity"
				editable: false
				type: "slider"
				min: 0
				value: 2
				max: 10
				name: "Red Velocity"
				label : "m/s"

			blueVelocity: 
				class: "blue_velocity"
				editable: false
				type: "slider"
				min: -10
				value: 0
				max: 0
				name: "Blue Velocity"
				label : "m/s"

			redMass:
				class: "red_mass"
				editable: false
				type: "slider"
				min: 1
				value: 3
				max: 10
				name: "Red Mass"
				label: "kg"

			blueMass:
				class: "blue_mass"
				editable: false
				type: "slider"
				min: 1
				value: 5
				max: 10
				name: "Blue Mass"
				label: "kg"

			frameVelocity:
				class: "frame_velocity"
				editable: false
				type: "slider"
				min: -10
				value: -1
				max: 0
				name: "Frame Velocity"
				label: "m/s"

	4:
		header : "Custom Frame of Reference"
		frame : "custom"
		controls : 

			redVelocity:
				class: "red_velocity"
				editable: false
				type: "slider"
				min: 0
				value: 5
				max: 10
				name: "Red Velocity"
				label : "m/s"

			blueVelocity: 
				class: "blue_velocity"
				editable: false
				type: "slider"
				min: -10
				value: -1
				max: 0
				name: "Blue Velocity"
				label : "m/s"

			redMass:
				class: "red_mass"
				editable: false
				type: "slider"
				min: 1
				value: 3
				max: 10
				name: "Red Mass"
				label: "kg"

			blueMass:
				class: "blue_mass"
				editable: false
				type: "slider"
				min: 1
				value: 5
				max: 10
				name: "Blue Mass"
				label: "kg"

			frameVelocity:
				class: "frame_velocity"
				editable: true
				type: "slider"
				min: -10
				value: 0				
				max: 10
				name: "Frame Velocity"
				label: "m/s"

}
