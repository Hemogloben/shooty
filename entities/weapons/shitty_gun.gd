extends "gun.gd"

export (PackedScene) var Bullet
var can_shoot = true
onready var shot_prevention_timer = Timer.new()

func _ready():
	._ready()
	reload()
	shot_prevention_timer.connect("timeout",self,"enable_shooting")
	shot_prevention_timer.one_shot = true
	add_child(shot_prevention_timer)

func _process(delta):
	._process(delta)
	if can_shoot and properties.magazine_current == 0:
		reload()
	if Input.is_action_pressed("action 1"):
		shoot()

func enable_shooting():
	can_shoot = true

func shoot():
	if can_shoot and properties.magazine_current > 0:
		can_shoot = false
		var angle_per_bullet = 5
		var half_angle = (angle_per_bullet * (properties.num_bullets - 1)) / 2.0
		for i in range(0, properties.num_bullets):
			var b = Bullet.instance()
			b.SetSpeed(properties.bullet_speed)
			b.SetDamage(properties.bullet_damage)
			bullet_pool.add_child(b)
			b.transform = $bullet_spawn.global_transform
			b.set_rotation(b.rotation - deg2rad(half_angle) + (deg2rad(i*angle_per_bullet)))
		properties.magazine_current -= 1
		if properties.magazine_current == 0:
			shot_prevention_timer.start(properties.reload_time)
		else:
			shot_prevention_timer.start(properties.time_between_shots)
		emit_signal("gun_properties_changed", properties)

func reload():
	properties.magazine_current = properties.magazine_max
	emit_signal("gun_properties_changed", properties)
