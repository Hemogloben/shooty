extends Node2D


onready var paused_screen = get_node("Paused").get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	paused_screen.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		var paused = get_tree().paused;
		paused = !paused
		get_tree().paused = paused
		
		if (paused):
			paused_screen.show()
		else:
			paused_screen.hide()
