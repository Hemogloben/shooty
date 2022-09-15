extends Area2D


export var speed = 175
var screen_size

onready var gun = $shitty_gun

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$player_sprite.play()
	$player_sprite.animation = "idle"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$player_sprite.play()
	else:
		$player_sprite.animation = "idle"
		
	position += velocity * delta
	if velocity.x != 0:
		$player_sprite.animation = "walk"
		$player_sprite.flip_v = false
		$player_sprite.flip_h = velocity.x < 0
	if velocity.y != 0:
		$player_sprite.animation = "walk"

func getGunProperties():
	return gun.getProperties()
