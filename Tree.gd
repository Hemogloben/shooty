extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	frame = randi() % 6
	scale = Vector2(5, 5)
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
