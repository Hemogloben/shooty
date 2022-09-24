extends Area2D

export var pickup_speed = 500

var picking_up = false

var player = null

onready var line = $Line2D

func set_picking_up(player):
	self.player = player
	picking_up = true

func _ready():
	if (line):
		line.set_as_toplevel(true)

func _process(delta):
	if (picking_up and player):
		var dir = (player.position - position).normalized()
		position += dir * pickup_speed * delta

func _physics_process(delta):
	line.add_point(global_position)
	if (line.points.size() > 150):
		line.remove_point(0)

func modifyProperties(props):
	push_warning("No modifyProperties implemented")

func _on_pickup_area_entered(area):
	if (area.is_in_group("player")):
		modifyProperties(area.getGunProperties())
		call_deferred("queue_free")
