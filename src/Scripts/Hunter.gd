extends "res://src/Scripts/NPC.gd"

signal enemyDead(enemy)

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
		position.x += moveSpeed * delta
		apply_animation()


func reset():
	_reset()
	anim.play("RESET")
	yield(anim, "animation_finished")
	attack_mode(dir)
	toggle_collisions(true)
	show()


func get_killed() -> void:
	emit_signal("enemyDead", self)
	dead = true
	attackMode = false
	toggle_collisions(false)
	bloodFX.emitting = true
	anim.play("death")
	decal.show()
	poolTimer.start()


func toggle_collisions(value: bool) -> void:
	attackArea.set_collision_layer_bit(3, value)
	attackArea.set_collision_mask_bit(3, value)
	self.set_collision_layer_bit(2, value)
	self.set_collision_mask_bit(2, value)


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
