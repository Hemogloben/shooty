extends Area2D

export var pickup_speed = 500

var picking_up = false

var player = null

func set_picking_up(new_player):
	player = new_player
	picking_up = true

func _process(delta):
	if (picking_up and player):
		var dir = (player.position - position).normalized()
		position += dir * pickup_speed * delta

func apply_pickup_to_area(_area):
	push_warning("No apply_pickup_to_area implemented")

func modifyProperties(_props):
	push_warning("No modifyProperties implemented")

func _on_pickup_area_entered(area):
	if (area.is_in_group("player")):
		apply_pickup_to_area(area)
		call_deferred("queue_free")
