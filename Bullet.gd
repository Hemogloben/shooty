extends Area2D

export var speed = 750
export var damage = 1
var destroy = false
onready var sprite = $AnimatedSprite

func _physics_process(delta):
	if !destroy:
		position += transform.x * speed * delta
	else:
		if !sprite.playing:
			queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_area_entered(area):
	if (area.is_in_group("mobs")):
		print(area.name + " Hit by Bullet")
		area.applyDamage(damage)
		destroy = true
		sprite.animation = "explosion"
		sprite.play()
