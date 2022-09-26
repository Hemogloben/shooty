extends Area2D

export var pickup_speed = 500
export var accel = 2.0
export var alpha = 0.1

var picking_up = false
var curr_dir = null;


var player = null

func set_picking_up(new_player):
	player = new_player
	picking_up = true
	if !curr_dir:
		curr_dir = -(player.position - position).normalized()


func _physics_process(delta):
	if (picking_up and player):
		var dir = (player.position - position).normalized()
		curr_dir = (1 - alpha) * curr_dir + alpha * dir
		position += curr_dir * pickup_speed * delta
		pickup_speed += min(accel * pickup_speed * delta, 2500)

func apply_pickup_to_area(_area):
	push_warning("No apply_pickup_to_area implemented")

func modifyProperties(_props):
	push_warning("No modifyProperties implemented")

func _on_pickup_area_entered(area):
	if (area.is_in_group("player")):
		apply_pickup_to_area(area)
		call_deferred("queue_free")
