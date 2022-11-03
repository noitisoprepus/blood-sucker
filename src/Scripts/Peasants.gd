extends Area2D

onready var anim = $AnimationPlayer
onready var col = $Character
onready var skin = $Character/Sprite
onready var decal = $Character/Sprite/BloodDecal
onready var blood = $Character/BloodDown
onready var timer = $Timer
onready var poolTimer = $PoolTimer

export var minSpeed: float = 0
export var maxSpeed: float = 1
export var minBlood: int = 5
export var maxBlood: int = 10
export(Array, Texture) var skins
export(Array, Texture) var decals

var random = RandomNumberGenerator.new()
var dir: Vector2
var bloodAva: int
var moveSpeed: float
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
	decal.hide()
	random.randomize()
	skin.texture = skins[random.randi_range(0, skins.size() - 1)]
	decal.texture = decals[random.randi_range(0, decals.size() - 1)]
	bloodAva = random.randi_range(minBlood, maxBlood)
	moveSpeed = random.randf_range(minSpeed, maxSpeed)
	anim.play("RESET")
	yield(anim, "animation_finished")
	panic_mode(dir)
	show()


func get_sucked() -> void:
	panicMode = false
	timer.start()
	col.disabled = true
	blood.emitting = true
	decal.show()


func _on_player_death() -> void:
	pass


func panic_mode(direction: Vector2) -> void:
	moveSpeed = abs(moveSpeed) * direction.x
	panicMode = true
	anim.play("panic")


func apply_animation() -> void:
	if (moveSpeed > 0):
		col.scale.x = 1
	elif (moveSpeed < 0):
		col.scale.x = -1


func _on_Timer_timeout():
	anim.play("death")
	poolTimer.start()


func _on_PoolTimer_timeout():
	# Put back to the pool
	self.hide()
