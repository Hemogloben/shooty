extends Node2D


export (PackedScene) var Enemy
var enemy_pool = null

var spawn_timer = Timer.new()
export var enemy_spawn_time = 1


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
	var x_range = Vector2(100, 400)
	var y_range = Vector2(100, 400)

	var random_x = randi() % int(x_range[1]- x_range[0]) + 1 + x_range[0] 
	var random_y =  randi() % int(y_range[1]-y_range[0]) + 1 + y_range[0]
	var random_pos = Vector2(random_x, random_y)

	e.transform = Transform2D.IDENTITY.translated(random_pos)
