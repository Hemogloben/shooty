extends "pickup.gd"

export var points = 5

func set_points(points):
	self.points = points

func apply_pickup_to_area(area):
	area.add_score(points)
