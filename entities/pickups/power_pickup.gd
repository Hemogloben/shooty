extends "pickup.gd"


func apply_pickup_to_area(area):
	modifyProperties(area.get_parent().getGunProperties())

func modifyProperties(_props):
	push_warning("No modifyProperties implemented")
