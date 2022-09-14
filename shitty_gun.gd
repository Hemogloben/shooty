extends AnimatedSprite


var Name = "ShittyGun"
export (PackedScene) var Bullet
var can_shoot = true
export var between_shots = .25
export var reload_time = .75
onready var firerate = Timer.new()
export var magazine_max = 5
var magazine_current = magazine_max
onready var weapon_box_ui = $weapon_box_ui
onready var player = get_node_or_null("../../")
onready var hud = null
onready var weapon_box = null
onready var hud_weapon_box_name_ui = null
onready var hud_weapon_box_ammo_count_ui = null

var bullet_pool = null

#func _init():
	#self.weapon_box_ui = get_node("/root/weapon_box_ui")
func updateAmmoText():
	if hud:
		hud_weapon_box_name_ui.text = "Gun: " + Name
		hud_weapon_box_ammo_count_ui.text = "Ammo: " + str(magazine_current)
	weapon_box_ui.text = getAmmoPips()

func getAmmoPips():
	var pips = ""
	var counter = 0
	for i in range(0, magazine_current):
		pips += "|"
		counter += 1
		if counter > 4:
			counter = 0
			pips += "\n"
	return pips

func _ready():
	firerate.connect("timeout",self,"_on_cooldown_timeout")
	firerate.one_shot = true
	add_child(firerate)
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


func _on_cooldown_timeout():
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
	if can_shoot and magazine_current > 0:
		can_shoot = false
		var b = Bullet.instance()
		bullet_pool.add_child(b)
		b.transform = $bullet_spawn.global_transform
		magazine_current -= 1
		if magazine_current == 0:
			firerate.start(reload_time)
			reload()
		else:
			firerate.start(between_shots)
		updateAmmoText()

func reload():
	magazine_current = magazine_max
	updateAmmoText()
