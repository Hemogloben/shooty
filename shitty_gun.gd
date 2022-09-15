extends AnimatedSprite

export (PackedScene) var Bullet
var can_shoot = true
onready var shot_prevention_timer = Timer.new()

onready var weapon_box_ui = $weapon_box_ui
onready var player = get_node_or_null("../")
onready var hud = null
onready var weapon_box = null
onready var hud_weapon_box_name_ui = null
onready var hud_weapon_box_ammo_count_ui = null

export (Dictionary) var properties = {
	name = "ShittyGun",
	time_between_shots = .25,
	reload_time = .75,
	magazine_max = 10,
	magazine_current = 5#properties.magazine_max
}

var bullet_pool = null

func updateAmmoText():
	if hud:
		hud_weapon_box_name_ui.text = "Gun: " + properties.name
		hud_weapon_box_ammo_count_ui.text = "Ammo: " + str(properties.magazine_current)
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
	properties.magazine_current = properties.magazine_max
	shot_prevention_timer.connect("timeout",self,"enable_shooting")
	shot_prevention_timer.one_shot = true
	add_child(shot_prevention_timer)
	bullet_pool = get_node_or_null("/root/Node2D/BulletPool")
	if (!bullet_pool):
		bullet_pool = get_node("/root")
	if player:
		hud = player.get_node_or_null("Camera2D/HUD")
		if hud:
			weapon_box = hud.get_node_or_null("WeaponHUD")
			if weapon_box:
				hud_weapon_box_name_ui = weapon_box.get_node_or_null("Panel/WeaponName")
				hud_weapon_box_ammo_count_ui = weapon_box.get_node_or_null("Panel/AmmoCount")
	updateAmmoText()


func enable_shooting():
	can_shoot = true


func _process(_delta):
	look_at(get_global_mouse_position())
	var rot = wrapf(rotation_degrees, 0, 360)
	if ((rot > 270) or (rot < 90)):
		scale = Vector2(1, 1)
	else:
		scale = Vector2(1, -1)
	if Input.is_action_pressed("action 1"):
		shoot()


func shoot():
	if can_shoot and properties.magazine_current > 0:
		can_shoot = false
		var b = Bullet.instance()
		bullet_pool.add_child(b)
		b.transform = $bullet_spawn.global_transform
		properties.magazine_current -= 1
		if properties.magazine_current == 0:
			shot_prevention_timer.start(properties.reload_time)
			reload()
		else:
			shot_prevention_timer.start(properties.time_between_shots)
		updateAmmoText()

func reload():
	properties.magazine_current = properties.magazine_max
	updateAmmoText()

func getProperties():
	return properties
