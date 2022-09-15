extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func modifyProperties(props):
	props.time_between_shots *= 0.5
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_pickup_area_entered(area):
	if (area.is_in_group("player")):
		modifyProperties(area.getGunProperties())
		call_deferred("queue_free")
