extends "res://src/Scripts/NPC.gd"

onready var anim = $AnimationPlayer
onready var attackArea = $Character/AttackArea
onready var poolTimer = $PoolTimer

var attackMode: bool = false


func _ready():
	var player = get_parent().get_parent().get_node("Player")
	player.connect("death", self, "_on_player_death")
	reset()


func _process(delta):
	if attackMode:
#		if !visible:
#			attackArea.set_collision_layer_bit(3, false)
#			attackArea.set_collision_mask_bit(3, false)
		position.x += moveSpeed * delta
		apply_animation()


func reset():
	_reset()
	anim.play("RESET")
	yield(anim, "animation_finished")
	attack_mode(dir)
	attackArea.set_collision_layer_bit(3, true)
	attackArea.set_collision_mask_bit(3, true)
	show()


func get_killed() -> void:
	dead = true
	attackMode = false
	attackArea.set_collision_layer_bit(3, false)
	attackArea.set_collision_mask_bit(3, false)
	bloodFX.emitting = true
	anim.play("death")
	decal.show()
	poolTimer.start()


func _on_player_death() -> void:
	if dead:
		return
	attackMode = false
	anim.play("default")


func attack_mode(direction: Vector2) -> void:
	moveSpeed = abs(moveSpeed) * direction.x
	attackMode = true
	anim.play("attack")


func _on_PoolTimer_timeout():
	# Put back to the pool
	self.hide()
