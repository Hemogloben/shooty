extends Area2D

export var speed = 750
export var damage = 1
var destroyed = false
onready var sprite = $AnimatedSprite

func _physics_process(delta):
	if !destroyed:
		position += transform.x * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func SetSpeed(new_speed):
	speed = new_speed
	
func SetDamage(new_damage):
	damage = new_damage

func _on_Bullet_area_entered(area):
	if (area.is_in_group("mobs") and !destroyed and area.isAlive()):
		print(area.name + " Hit by Bullet")
		area.applyDamage(damage)
		destroyed = true
		sprite.animation = "explosion"
		sprite.play()
		sprite.connect("animation_finished", self, "_on_VisibilityNotifier2D_screen_exited")
