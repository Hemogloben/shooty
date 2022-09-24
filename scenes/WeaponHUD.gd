extends Node

onready var player = get_node_or_null("../../../")
onready var WeaponName = get_node("Panel/WeaponName")
onready var AmmoCount = get_node("Panel/AmmoCount")
var gun = null
# Called when the node enters the scene tree for the first time.
func _ready():
	if (player):
		player.connect("gun_changed", self, "connectGun")

func connectGun(new_gun):
	if (gun):
		gun.disconnect("gun_properties_changed", self, "UpdateGunProperties")
	gun = new_gun
	gun.connect("gun_properties_changed", self, "UpdateGunProperties")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func UpdateGunProperties(props):
	SetWeaponName(props.name)
	SetAmmoCount(props.magazine_current)

func SetWeaponName(name):
	WeaponName.text = "Gun: " + name
	
func SetAmmoCount(ammo_count):
	AmmoCount.text = "Ammo: " + str(ammo_count)
