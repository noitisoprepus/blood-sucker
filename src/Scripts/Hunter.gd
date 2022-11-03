extends Area2D

onready var anim = $AnimationPlayer
onready var col = $Character
onready var skin = $Character/Sprite
onready var decal = $Character/Sprite/BloodDecal
onready var blood = $Character/BloodSplat
onready var attackArea = $Character/AttackArea
onready var poolTimer = $PoolTimer

export var minSpeed: float = 0
export var maxSpeed: float = 1
export(Array, Texture) var skins
export(Array, Texture) var decals

var random = RandomNumberGenerator.new()
var dir: Vector2
var moveSpeed: float
var attackMode: bool = false


func _ready():
	var player = get_parent().get_parent().get_node("Player")
	player.connect("death", self, "_on_player_death")
	reset()


func _process(delta):
	if attackMode:
		if !visible:
			attackArea.set_collision_layer_bit(3, false)
			attackArea.set_collision_mask_bit(3, false)
		position.x += moveSpeed * delta
		apply_animation()


func reset():
	decal.hide()
	random.randomize()
	skin.texture = skins[random.randi_range(0, skins.size() - 1)]
	decal.texture = decals[random.randi_range(0, decals.size() - 1)]
	moveSpeed = random.randf_range(minSpeed, maxSpeed)
	anim.play("RESET")
	yield(anim, "animation_finished")
	attack_mode(dir)
	attackArea.set_collision_layer_bit(3, true)
	attackArea.set_collision_mask_bit(3, true)
	show()


func get_killed() -> void:
	attackMode = false
	attackArea.set_collision_layer_bit(3, false)
	attackArea.set_collision_mask_bit(3, false)
	blood.emitting = true
	anim.play("death")
	decal.show()
	poolTimer.start()


func _on_player_death() -> void:
	attackMode = false
	anim.play("default")


func attack_mode(direction: Vector2) -> void:
	moveSpeed = abs(moveSpeed) * direction.x
	attackMode = true
	anim.play("attack")


func apply_animation() -> void:
	if (moveSpeed > 0):
		col.scale.x = 1
	elif (moveSpeed < 0):
		col.scale.x = -1


func _on_PoolTimer_timeout():
	# Put back to the pool
	self.hide()
