extends Area2D

export var pickup_speed = 500

var picking_up = false

var player = null

func set_picking_up(player):
	self.player = player
	picking_up = true

func _process(delta):
	if (picking_up and player):
		var dir = (player.position - position).normalized()
		position += dir * pickup_speed * delta

func modifyProperties(props):
	push_warning("No modifyProperties implemented")

func _on_pickup_area_entered(area):
	if (area.is_in_group("player")):
		modifyProperties(area.getGunProperties())
		call_deferred("queue_free")
