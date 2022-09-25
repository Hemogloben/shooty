extends Node2D


onready var player = get_node("../Player")
onready var paused_screen = get_node("Paused").get_child(0)
onready var game_over_screen = get_node("GameOver").get_child(0)
onready var restart_button = get_node("GameOver/PanelContainer/VBoxContainer/Restart")
var game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	paused_screen.hide()
	game_over_screen.hide()
	player.connect("game_over", self, "end_game")
	restart_button.connect("button_down", self, "restart")


func end_game():
	game_over = true
	get_tree().paused = true
	game_over_screen.show()

func restart():
	get_tree().change_scene("res://scenes/Game.tscn")
	game_over = false
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not game_over and Input.is_action_just_pressed("pause"):
		var paused = get_tree().paused;
		paused = !paused
		get_tree().paused = paused
		
		if (paused):
			paused_screen.show()
		else:
			paused_screen.hide()
