extends "power_pickup.gd"	

func modifyProperties(props):
	#props.time_between_shots *= 0.5
	#props.bullet_speed = 3000
	#props.bullet_damage = 4
	print("Num Bullets Before: " + str(props.num_bullets))
	props.num_bullets += 1
	print("Num Bullets After: " + str(props.num_bullets))
