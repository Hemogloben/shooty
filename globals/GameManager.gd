extends Node2D


onready var player = get_node("../Player")
onready var game_over_screen = get_node("GameOver").get_child(0)
onready var restart_button = get_node("GameOver/PanelContainer/VBoxContainer/Restart")
var game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	PauseMenu.can_show = true
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

