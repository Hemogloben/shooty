extends Area2D


export var speed = 175
onready var enemy_sprite = $enemy_sprite
onready var health_bar = $health_bar
var health = 4
onready var isSceneTest = (get_parent() == get_tree().root)
var autonomous = !isSceneTest
var heading_alpha = 0.7
var heading_dir = Vector2(0, 0)

onready var player = null

func getHealthPips():
	var pips = ""
	for i in range(0, health):
		pips += "|"
	return pips	

func applyDamage(damage):
	health -= damage

func isAlive():
	return health > 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if !isSceneTest:
		player = get_node("/root/Node2D/Player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.text = getHealthPips()
	if health <= 0:
		get_parent().remove_child(self)
	
	var velocity = Vector2.ZERO
	if isSceneTest:
		# If we're running this scene by itself we want to test enemy
		# motion, animations and behaviors
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_right"):
			velocity.x += 1	
		if Input.is_action_just_pressed("ui_focus_next"):
			autonomous = !autonomous
	if autonomous:
		var new_heading = Vector2()
		if isSceneTest:
			new_heading = get_global_mouse_position() - position
		else:
			new_heading = player.position - position
		var alpha = heading_alpha * delta			
		heading_dir = (1.0 - alpha) * heading_dir + alpha * (new_heading)
		velocity = heading_dir	
	processMotion(velocity, delta)
		
func processMotion(velocity, delta):
	if velocity.length() != 0.0:
		velocity = velocity.normalized() * speed
		$enemy_sprite.play()
	else:
		$enemy_sprite.animation = "idle"
		$enemy_sprite.play()
		
	position += velocity * delta
	if velocity.x != 0:
		$enemy_sprite.animation = "walk"
		$enemy_sprite.flip_v = false
		$enemy_sprite.flip_h = velocity.x < 0
	if velocity.y != 0:
		$enemy_sprite.animation = "walk"
