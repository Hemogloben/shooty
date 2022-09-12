extends Node2D


export (PackedScene) var Enemy
var enemy_pool = null

var spawn_timer = Timer.new()
export var enemy_spawn_time = 1
export var radius_to_spawn = 500

onready var player = get_node("/root/Node2D/Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	enemy_pool = get_node_or_null("/root/Node2D/EnemyPool")
	if (!enemy_pool):
		enemy_pool = get_node("/root")
	spawn_timer.connect("timeout", self, "CreateEnemy")
	spawn_timer.wait_time = enemy_spawn_time
	spawn_timer.one_shot = false
	add_child(spawn_timer)
	spawn_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func CreateEnemy():
	var e = Enemy.instance()
	enemy_pool.add_child(e)

	var angle = randf() * 360
	var x = radius_to_spawn * cos(angle * PI / 180)
	var y = radius_to_spawn * sin(angle * PI / 180)
	var random_pos = Vector2(x + player.position.x, y + player.position.y)

	e.transform = Transform2D.IDENTITY.translated(random_pos)
