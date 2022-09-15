extends Area2D

func modifyProperties(props):
	push_warning("No modifyProperties implemented")

func _on_pickup_area_entered(area):
	if (area.is_in_group("player")):
		modifyProperties(area.getGunProperties())
		call_deferred("queue_free")
