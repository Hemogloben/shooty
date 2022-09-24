extends "pickup.gd"


func apply_pickup_to_area(area):
	modifyProperties(area.getGunProperties())

func modifyProperties(props):
	push_warning("No modifyProperties implemented")
