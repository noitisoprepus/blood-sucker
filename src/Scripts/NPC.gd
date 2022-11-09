extends Area2D

export(float) var minSpeed: float = 0
export(float) var maxSpeed: float = 1
export(Array, Texture) var skins
export(Array, Texture) var decals

export(NodePath) var character
export(NodePath) var skin
export(NodePath) var decal
export(NodePath) var bloodFX

var random = RandomNumberGenerator.new()
var dir: Vector2
var moveSpeed: float
var dead: bool


func _ready():
	character = get_node(character)
	skin = get_node(skin)
	decal = get_node(decal)
	bloodFX = get_node(bloodFX)


func _reset():
	random.randomize()
	skin.texture = skins[random.randi_range(0, skins.size() - 1)]
	decal.texture = decals[random.randi_range(0, decals.size() - 1)]
	moveSpeed = random.randf_range(minSpeed, maxSpeed)
	dead = false
	decal.hide()


func apply_animation() -> void:
	if (moveSpeed > 0):
		character.scale.x = 1
	elif (moveSpeed < 0):
		character.scale.x = -1
