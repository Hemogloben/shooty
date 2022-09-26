extends KinematicBody2D


export (PackedScene) var drop

export(Array, PackedScene) var drops
export (Array, float) var drop_percents

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
	for _i in range(0, health):
		pips += "|"
	return pips	

func applyDamage(damage):
	health -= damage
	if health <= 0:
		kill()

func isAlive():
	return health > 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if !isSceneTest:
		player = get_node("/root/Node2D/Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	health_bar.text = getHealthPips()

	
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
		var alpha = 1#heading_alpha * delta			
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
		
	#position += velocity * delta
	var col = move_and_collide(velocity * delta)
	if col:
		heading_alpha = 1
		var random_dir_change = -1 if randf() < 0.5 else 1
		move_and_collide(col.remainder.slide(col.normal.tangent() * random_dir_change))
	else:
		heading_alpha = 0.7
	if velocity.x != 0:
		$enemy_sprite.animation = "walk"
		$enemy_sprite.flip_v = false
		$enemy_sprite.flip_h = velocity.x < 0
	if velocity.y != 0:
		$enemy_sprite.animation = "walk"

func kill():
	drop_loot()
	get_parent().remove_child(self)
	queue_free()

func drop_loot():
	var r = randf()
	var i = 0
	var total_percent = 0
	for percent in drop_percents:
		total_percent += percent
		if r < total_percent:
			print("Drop r: " + str(r) + ", total: " + str(total_percent))
			var loot = drops[i].instance()
			loot.position = position
			get_parent().call_deferred("add_child", loot)#add_child(loot)
			break
		i += 1
