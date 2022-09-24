extends Node2D

signal gun_properties_changed(props)

export (Dictionary) var properties = {
	name = "ShittyGun",
	time_between_shots = .25,
	reload_time = .75,
	magazine_max = 10,
	magazine_current = 5,#properties.magazine_max
	bullet_speed = 750,
	bullet_damage = 2
}

var bullet_pool = null


# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_pool = get_node_or_null("/root/Node2D/BulletPool")
	if (!bullet_pool):
		bullet_pool = get_node("/root")

func _process(_delta):
	look_at(get_global_mouse_position())
	var rot = wrapf(rotation_degrees, 0, 360)
	if ((rot > 270) or (rot < 90)):
		scale = Vector2(1, 1)
	else:
		scale = Vector2(1, -1)

func force_emit_gun_signal():
	emit_signal("gun_properties_changed", properties)

func getProperties():
	return properties
