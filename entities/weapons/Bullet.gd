extends Area2D

export var speed = 750
export var damage = 1
export var bullet_bounces = 2
var destroyed = false
onready var sprite = $AnimatedSprite

func _physics_process(delta):
	if !destroyed:
		position += transform.x * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func SetProperties(props):
	speed = props.bullet_speed
	damage = props.bullet_damage
	bullet_bounces = props.num_bullet_bounces

func _on_Bullet_area_entered(area):
	if (area.is_in_group("mobs") and !destroyed and area.isAlive()):
		print(area.name + " Hit by Bullet")
		area.applyDamage(damage)
		if bullet_bounces == 0:
			destroyed = true
			sprite.animation = "explosion"
			sprite.play()
			sprite.connect("animation_finished", self, "_on_VisibilityNotifier2D_screen_exited")
		else:
			bullet_bounces -= 1
			rotation += to_global(position + Vector2(0, 1)).angle_to(global_position - area.global_position)
