extends Node

var Tree

export var tree_origin_spacing_avg = 1300
export var tree_spacing_variation = 800

onready var player = get_node("/root/Node2D/Player")
onready var screen_size = get_viewport().size

# Already Generated Tree Indices
# Pos = 
# - x_extents * tree_origin_spacing_avg
# - y_extents * tree_origin_spacing_avg
var x_extents = [0, 0] # Already Generated Tree Indices x
var y_extents = [0, 0] # Already Generated Tree Indices y

func init(tree_scene):
	Tree = tree_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GenerateTrees([-5000, 5000], [-5000, 5000])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var screen_right = player.position.x + screen_size.x * 4
	var screen_left = player.position.x - screen_size.x * 4
	var screen_top = player.position.y - screen_size.y * 4
	var screen_bottom = player.position.y + screen_size.y * 4
	if ((screen_right > ((x_extents[1] + 1) * tree_origin_spacing_avg))
		or (screen_left < ((x_extents[0] - 1) * tree_origin_spacing_avg))
		or (screen_top < ((y_extents[0] - 1) * tree_origin_spacing_avg))
		or (screen_bottom > ((y_extents[1] + 1) * tree_origin_spacing_avg))):
		GenerateTrees([min(screen_left, x_extents[0] * tree_origin_spacing_avg), 
					   max(screen_right, x_extents[1] * tree_origin_spacing_avg)],
					   [min(screen_top, y_extents[0] * tree_origin_spacing_avg),
						max(screen_bottom, y_extents[1] * tree_origin_spacing_avg)])

func GenerateTrees(x_range, y_range):
	var x_i_range = [floor(x_range[0] / tree_origin_spacing_avg), floor(x_range[1] / tree_origin_spacing_avg)]
	var y_i_range = [floor(y_range[0] / tree_origin_spacing_avg), floor(y_range[1] / tree_origin_spacing_avg)]
	print("X: ", x_i_range)
	print("Y: ", y_i_range)
	print("Xe: ", x_extents)
	print("Ye: ", y_extents)	
	var counter = 0
	for y in range(y_i_range[0], y_i_range[1]):	
		for x in range(x_i_range[0], x_i_range[1]):
			if ((y < y_extents[0] or y > y_extents[1]) or (x < x_extents[0] or x > x_extents[1])):
				var x_offset = x * tree_origin_spacing_avg
				if (counter % 2 == 0):
					x_offset += tree_origin_spacing_avg * 0.5
				CreateTree(Vector2(x_offset, y * tree_origin_spacing_avg))
		counter += 1 
	x_extents = x_i_range
	y_extents = y_i_range	

func CreateTree(origin):
	var t = Tree.instance()
	get_node("/root/Node2D").call_deferred("add_child", t)

	var half_tree_spacing = tree_spacing_variation * 0.5
	var x_range = Vector2(-half_tree_spacing, half_tree_spacing)
	var y_range = Vector2(-half_tree_spacing, half_tree_spacing)

	var random_x = randi() % int(x_range[1]- x_range[0]) + 1 + x_range[0] 
	var random_y =  randi() % int(y_range[1]-y_range[0]) + 1 + y_range[0]
	var random_pos = Vector2(random_x, random_y)

	t.transform = Transform2D.IDENTITY.translated(random_pos + origin)
