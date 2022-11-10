extends "res://src/Scripts/NPC.gd"

onready var anim = $AnimationPlayer
onready var poolTimer = $PoolTimer

export var minBlood: int = 5
export var maxBlood: int = 10

var bloodAva: int
var panicMode: bool = false


func _ready():
	var player = get_parent().get_parent().get_node("Player")
	player.connect("death", self, "_on_player_death")
	reset()


func _process(delta):
	if panicMode:
		position.x += moveSpeed * delta
		apply_animation()


func reset():
	_reset()
	bloodAva = random.randi_range(minBlood, maxBlood)
	character.disabled = false
	anim.play("RESET")
	yield(anim, "animation_finished")
	panic_mode(dir)
	show()


func get_sucked() -> void:
	dead = true
	panicMode = false
	character.disabled = true
	bloodFX.emitting = true
	decal.show()
	anim.play("death")
	yield(anim, "animation_finished")
	poolTimer.start()


func _on_player_death() -> void:
	if dead:
		return
	anim.play("default")
	moveSpeed = moveSpeed * 0.4


func panic_mode(direction: Vector2) -> void:
	moveSpeed = abs(moveSpeed) * direction.x
	panicMode = true
	anim.play("panic")


func _on_PoolTimer_timeout():
	# Put back to the pool
	self.hide()
