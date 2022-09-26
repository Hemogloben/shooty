extends CanvasLayer

onready var player = get_node("../../Player")
onready var panel = get_node("Panel")
onready var upgrades_label = get_node("Panel/Label")
onready var firerate_btn = get_node("Panel/HBoxContainer/FireRate")
onready var magazine_btn = get_node("Panel/HBoxContainer/Magazine")
onready var reload_btn = get_node("Panel/HBoxContainer/Reload")
onready var num_bullets_btn = get_node("Panel/HBoxContainer/NumBullets")
onready var bounce_btn = get_node("Panel/HBoxContainer/Bounce")
onready var enemy_bullet_btn = get_node("Panel/HBoxContainer/EnemyBullet")
onready var enemy_bounce_btn = get_node("Panel/HBoxContainer/EnemyBounce")

var upgrade_score_inc = 100
var last_upgraded_score = 0
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	panel.hide()
	player.connect("score_changed", self, "score_changed")
	firerate_btn.connect("pressed", self, "firerate_upgrade")
	magazine_btn.connect("pressed", self, "magazine_upgrade")
	reload_btn.connect("pressed", self, "reload_upgrade")
	num_bullets_btn.connect("pressed", self, "num_bullets_upgrade")
	bounce_btn.connect("pressed", self, "bounce_upgrade")
	enemy_bullet_btn.connect("pressed", self, "enemy_bullet_upgrade")
	enemy_bounce_btn.connect("pressed", self, "enemy_bounce_upgrade")

func score_changed(new_score):
	score = new_score
	if ((score - last_upgraded_score) >= upgrade_score_inc):
		get_tree().paused = true
		panel.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func firerate_upgrade():
	var props = player.getGunProperties()
	props.time_between_shots *= 0.9
	finalize_upgrade()

func magazine_upgrade():
	var props = player.getGunProperties()
	props.magazine_max += 1
	props.magazine_current = props.magazine_max
	finalize_upgrade()

func reload_upgrade():
	var props = player.getGunProperties()
	props.reload_time *= 0.9
	props.magazine_current = props.magazine_max
	finalize_upgrade()

func num_bullets_upgrade():
	var props = player.getGunProperties()
	props.num_bullets += 1
	finalize_upgrade()

func bounce_upgrade():
	var props = player.getGunProperties()
	props.num_bullet_bounces += 1
	finalize_upgrade()

func enemy_bullet_upgrade():
	var props = player.getGunProperties()
	props.enemy_bullet_spawn += 1
	finalize_upgrade()

func enemy_bounce_upgrade():
	var props = player.getGunProperties()
	props.enemy_bullet_bounce += 1
	finalize_upgrade()

func finalize_upgrade():
	last_upgraded_score += upgrade_score_inc
	if (score - last_upgraded_score) <= upgrade_score_inc:
		get_tree().paused = false
		panel.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


