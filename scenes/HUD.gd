extends CanvasLayer

onready var player = get_node_or_null("../../")
onready var score_ui = get_node("Score/Panel/Label")

func _ready():
	if (player):
		player.connect("score_changed", self, "update_score")

func update_score(score):
	score_ui.text = "Score: " + str(score)
