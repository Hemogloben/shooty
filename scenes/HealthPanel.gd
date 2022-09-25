extends Panel

onready var hbox = get_node("HBoxContainer")
export (PackedScene) var Heart



func SetHealth(props):
	hbox.set("custom_constants/separation", 26)
	var max_health_diff = props.max_health - hbox.get_child_count()
	if (max_health_diff > 0):
		for _i in range(0, abs(max_health_diff)):
			var heart = Heart.instance()
			hbox.add_child(heart)
#	if (max_health_diff < 0):
#		for i in range(0, abs(max_health_diff)):
	var hearts = hbox.get_children()
	for i in range(0, hbox.get_child_count()):
		#hbox.fit_child_in_rect(hearts[i], Rect2(Vector2(), hbox.rect_size))
		if i < props.health_current:
			hearts[i].get_child(0).frame = 0
		else:
			hearts[i].get_child(0).frame = 1	
	print("Num Children: " + str(hbox.get_child_count()))
		
		
