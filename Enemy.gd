extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var enemy_sprite = $enemy_sprite
onready var health_bar = $health_bar
var health = 4

func getHealthPips():
	var pips = ""
	for i in range(0, health):
		pips += "|"
	return pips	

func applyDamage(damage):
	health -= damage

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.text = getHealthPips()
	if not enemy_sprite.playing:
		enemy_sprite.play()
	if health <= 0:
		get_parent().remove_child(self)
