extends AnimatedSprite

onready var player = get_node("../Player")
var gun = null
onready var ammo_count = $AmmoCount

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	MenuEvent.connect("Paused", self, "paused")
	Game.connect("Resume", self, "resumed")
	player.connect("gun_changed", self, "gun_changed")
	gun_changed(player.get_node("shitty_gun"))
	gun.force_emit_gun_signal()

func paused(_paused):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resumed():
	Input.call_deferred("set_mouse_mode", Input.MOUSE_MODE_HIDDEN)

func gun_changed(new_gun):
	gun = new_gun
	gun.connect("gun_properties_changed", self, "gun_props")

func gun_props(props):	
	ammo_count.text = str(props.magazine_current)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position()
