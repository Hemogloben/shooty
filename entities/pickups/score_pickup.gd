extends "pickup.gd"

export var points = 5

func set_points(new_points):
	points = new_points

func apply_pickup_to_area(area):
	area.get_parent().add_score(points)
