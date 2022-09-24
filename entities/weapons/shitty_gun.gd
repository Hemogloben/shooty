extends "gun.gd"

export (PackedScene) var Bullet
var can_shoot = true
onready var shot_prevention_timer = Timer.new()

onready var weapon_box_ui = $weapon_box_ui

func updateAmmoText():
	weapon_box_ui.text = getAmmoPips(properties.magazine_current)

func getAmmoPips(ammo):
	var pips = ""
	var counter = 0
	for _i in range(0, ammo):
		pips += "|"
		counter += 1
		if counter > 4:
			counter = 0
			pips += "\n"
	return pips

func _ready():
	._ready()
	reload()
	shot_prevention_timer.connect("timeout",self,"enable_shooting")
	shot_prevention_timer.one_shot = true
	add_child(shot_prevention_timer)
	updateAmmoText()

func _process(delta):
	._process(delta)
	if Input.is_action_pressed("action 1"):
		shoot()

func enable_shooting():
	can_shoot = true

func shoot():
	if can_shoot and properties.magazine_current > 0:
		can_shoot = false
		var half_angle = (5 * properties.num_bullets) / 2.0
		for i in range(0, properties.num_bullets):
			var b = Bullet.instance()
			b.SetSpeed(properties.bullet_speed)
			b.SetDamage(properties.bullet_damage)
			bullet_pool.add_child(b)
			b.transform = $bullet_spawn.global_transform
			b.set_rotation(b.rotation - deg2rad(half_angle) + (deg2rad(i*5)))
		properties.magazine_current -= 1
		if properties.magazine_current == 0:
			shot_prevention_timer.start(properties.reload_time)
			reload()
		else:
			shot_prevention_timer.start(properties.time_between_shots)
		updateAmmoText()
		emit_signal("gun_properties_changed", properties)

func reload():
	properties.magazine_current = properties.magazine_max
	updateAmmoText()
