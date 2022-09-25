extends CanvasLayer

onready var player = get_node_or_null("/root/Node2D/Player")
onready var score_ui = get_node("Score/Panel/Label")

onready var health_ui = get_node("HealthPanel")

func _ready():
	if (player):
		player.connect("score_changed", self, "update_score")
		player.connect("health_changed", health_ui, "SetHealth")

func update_score(score):
	score_ui.text = "Score: " + str(score)
