extends Area2D


export var speed = 175
var score = 0

onready var gun = $shitty_gun
export var invulnerable_time = 2
onready var invulnerable_timer = Timer.new()
var invulnerable = false
export (Dictionary) var properties = {
	max_health = 4,
	health_current = 4
}

signal gun_changed(gun)
signal score_changed(score)
signal health_changed(props)
signal game_over

# Called when the node enters the scene tree for the first time.
func _ready():
	$player_sprite.play()
	$player_sprite.animation = "idle"
	emit_signal("gun_changed", gun)
	emit_signal("score_changed", score)
	gun.force_emit_gun_signal()
	emit_signal("health_changed", properties)

	invulnerable_timer.connect("timeout",self,"remove_invulnerability")
	invulnerable_timer.one_shot = true
	add_child(invulnerable_timer)

func remove_invulnerability():
	invulnerable = false

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
		
	var animation = "idle"
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$player_sprite.play()
	else:
		animation = "idle"

	position += velocity * delta
	if velocity.x != 0:
		animation = "walk"
		$player_sprite.flip_v = false
		$player_sprite.flip_h = velocity.x < 0
	if velocity.y != 0:
		animation = "walk"
	if invulnerable:
		animation += "_hurt"
	$player_sprite.animation = animation

func add_score(score):
	self.score += score
	emit_signal("score_changed", self.score)


func getGun():
	return gun

func getGunProperties():
	return gun.getProperties()

func _on_Player_area_entered(area):
	if area.is_in_group("mobs") and not invulnerable:
		properties.health_current -= 1
		# if (properties.health_current < 0):
			# properties.health_current = 0
		print("Health: " + str(properties.health_current))	
		emit_signal("health_changed", properties)
		invulnerable = true
		invulnerable_timer.start(invulnerable_time)
	if properties.health_current == 0:
		emit_signal("game_over")



func _on_PickupArea_area_entered(area:Area2D):
	if area.is_in_group("pickups"):
		area.set_picking_up(self)

