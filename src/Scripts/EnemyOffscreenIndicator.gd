extends Control

export(NodePath) var camera
export(NodePath) var spawner
export(float) var screenWidth: float

enum sideEnums {LEFT, RIGHT}	# LEFT - 0; RIGHT - 1
export(sideEnums) var side

onready var indicator = $TextureRect

var enemies: Array
var enemiesOnScreen: Array


func _ready():
	camera = get_node(camera)
	spawner = get_node(spawner)
	spawner.connect("enemySpawned", self, "_add_tracker")
	indicator.hide()


func _process(delta):
	if !enemies.empty():
		for i in range(enemies.size()):
			_check_tracker(enemies[i])


func _add_tracker(enemy) -> void:
	enemies.append(enemy)


# TODO: Take note of enemies onscreen and enemies offscreen when toggling indicator
func _check_tracker(enemy) -> void:
	match side:
		0:
			var distance = camera.position.x - (screenWidth / 2)
			if enemy.position.x < distance:
				if !indicator.visible:
					indicator.show()
			else:
				enemiesOnScreen.append(enemy)
				indicator.hide()
		1:
			var distance = camera.position.x + (screenWidth / 2)
			if enemy.position.x > distance:
				if !indicator.visible:
					indicator.show()
			else:
				indicator.hide()
