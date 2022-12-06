extends Control

export(NodePath) var camera
export(NodePath) var spawner
export(float) var screenWidth: float

enum sideEnums {LEFT, RIGHT}	# LEFT - 0; RIGHT - 1
export(sideEnums) var side

onready var indicator = $WarningSign
onready var anim = $AnimationPlayer

var enemies: Array


func _ready():
	camera = get_node(camera)
	spawner = get_node(spawner)
	spawner.connect("enemySpawned", self, "_add_tracker")
	indicator.hide()


func _process(delta):
	if !enemies.empty():
		for i in enemies.size():
			_check_tracker(enemies[i])


func _add_tracker(enemy) -> void:
	enemy.connect("enemyDead", self, "_remove_tracker", [], 4)
	enemies.append(enemy)


func _remove_tracker(enemy) -> void:
	enemies.erase(enemy)


func _check_tracker(enemy) -> void:
	match side:
		0:
			var distance = camera.position.x - (screenWidth / 2)
			if enemy.position.x < distance:
				if !indicator.visible:
					indicator.show()
					anim.play("Blink")
				return
		1:
			var distance = camera.position.x + (screenWidth / 2)
			if enemy.position.x > distance:
				if !indicator.visible:
					indicator.show()
					anim.play("Blink")
				return
	
	# When enemy is within camera bounds
	_remove_tracker(enemy)
	if enemies.size() < 1:
		indicator.hide()
		anim.play("RESET")
