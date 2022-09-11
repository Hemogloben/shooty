extends AnimatedSprite


var Name = "ShittyGun"
export (PackedScene) var Bullet
var can_shoot = true ##if you are able to shoot, related to between_shots
export var between_shots = .25
onready var firerate = $cooldown
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
	weapon_box_ui.text = getAmmoPips()
	print(magazine_current)
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
	if hud:
		hud_weapon_box_name_ui.text = "Gun: " + Name
		hud_weapon_box_ammo_count_ui.text = "Ammo: " + str(magazine_current)				

func _on_cooldown_timeout():
	can_shoot = true
	firerate.start()

func _process(_delta):
	look_at(get_global_mouse_position())
	var rot = wrapf(rotation_degrees, 0, 360)
	if ((rot > 270) or (rot < 90)):
		scale = Vector2(1, 1)
	else:
		scale = Vector2(1, -1)
	get_input()
	
## get_input() exists because i read a post saying that you wouldnt want 
## a reload funcion in the _process(_delta) function
## it didnt seem to help. 
func get_input():
	if Input.is_action_pressed("action 1"):
		shoot()
		
func shoot():
	if can_shoot and magazine_current > 0:
		var b = Bullet.instance()
		bullet_pool.add_child(b)
		b.transform = $bullet_spawn.global_transform
		firerate.start(between_shots)
		can_shoot = false
		magazine_current -= 1
		print(magazine_current)
		weapon_box_ui.text = getAmmoPips()
		if hud:
			hud_weapon_box_ammo_count_ui.text = "Ammo: " + str(magazine_current)
	elif magazine_current == 0:
		reload()
		##is this even the right way to do this? using an if/elif thing? 
		##it seems like its saying "if you have bullets and can shoot, then shoot
		##else, reload. so maybe it should just be if/else?

func reload():
	magazine_current = magazine_max
	print("reloading")
	print(magazine_current)
	print(can_shoot)
	can_shoot = true
	print(can_shoot)
	##this function seems to be running every frame action 1 is held
	##so the output just reads "5 reloading 5 reloading" over and over
	##it sets can_shoot to true, and magazine current to 5. im not sure why 
	##func shoot() does not want to work after the first 5 bullets are fired


