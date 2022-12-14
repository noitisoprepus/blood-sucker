extends KinematicBody2D

signal drank_blood(newAmount)
signal death

onready var character = $Character
onready var suckAlert = $Character/SuckAlert
onready var hurtArea = $Character/HurtArea
onready var slash = $Character/Attack_Slash
onready var slashAnim = $Character/Attack_Slash/AnimationPlayer
onready var attackTimer = $AttackTimer
onready var anim = $AnimationPlayer
onready var instinct = $Character/SuckInstinct
onready var instinctAnim = $Character/SuckInstinct/InstinctAnimator
onready var bloodSplat = $Character/BloodSplat
onready var suckSFX = $Character/SuckAlert/AudioStreamPlayer
onready var stabSFX = $Character/HurtArea/AudioStreamPlayer
onready var slashSFX = $Character/Attack_Slash/AudioStreamPlayer

export var maxSpeed: float = 100
export var accel: float = 200

export var slashPr: int = 10
export var slashCd: float = 1.0

var movement:= Vector2.ZERO
var canAttack: bool
var canSuck: bool
var isAttacking: bool
var isSucking: bool
var dead: bool
var prey
var blood: float


func _ready():
	reset()
	instinct.hide()


func _process(delta):
	# Feed Controls
	if Input.is_action_just_pressed("ui_up") and canSuck and !dead and prey != null:
		_suck()
	# Slash Controls
	if Input.is_action_just_pressed("ui_down") and canAttack and blood >= slashPr and !dead:
		_slash()


func _physics_process(delta):
	var axis := Vector2.ZERO
	if !isSucking and !isAttacking and !dead:
		axis = get_input()
	
	if(axis != Vector2.ZERO):
		apply_movement(axis * accel * delta)
	else:
		apply_friction(accel * delta)
	movement = move_and_slide(movement)
	apply_movement_animation()


func reset():
	dead = false
	canAttack = true
	canSuck = false
	isAttacking = false
	isSucking = false
	hurtArea.set_deferred("monitoring", true)
	suckAlert.set_deferred("monitoring", true)
	slash.hide()


func get_input():
	var axis := Vector2.ZERO
	axis.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return axis.normalized()


func apply_friction(amount):
	if(movement.length() > amount):
		movement -= movement.normalized() * amount
	else:
		movement = Vector2.ZERO


func apply_movement(acceleration):
	movement += acceleration
	if (movement.length() > maxSpeed):
		movement = movement.limit_length(maxSpeed)


func apply_movement_animation():
	if (movement.x > 0):
		character.scale.x = 1
	elif (movement.x < 0):
		character.scale.x = -1


func _suck() -> void:
	isSucking = true
	canSuck = false
	canAttack = false
	instinctAnim.play("active")

	prey.get_sucked()
	var newBlood = blood + prey.bloodAva
	blood = clamp(newBlood, 0, 100)
	prey = null
	suckAlert.monitoring = false

	suckSFX.play()
	anim.play("suck_stand")
	yield(anim, "animation_finished")
	instinct.hide()
	instinctAnim.play("RESET")
	suckAlert.monitoring = true
	emit_signal("drank_blood", blood)
	isSucking = false
	canAttack = true


func _slash() -> void:
	isAttacking = true
	canSuck = false
	var newBlood = blood - slashPr
	blood = clamp(newBlood, 0, 100)
	emit_signal("drank_blood", blood)
	slash.show()
	slashSFX.play()
	slashAnim.play("slash")
	yield(slashAnim, "animation_finished")
	slash.hide()
	isAttacking = false
	canSuck = true
	attackTimer.start()


func _dead() -> void:
	dead = true
	emit_signal("death")
	invulnerable()
	instinct.hide()
	bloodSplat.amount = 15 + (blood / 2)
	bloodSplat.emitting = true
	stabSFX.play()
	anim.play("death")
	yield(anim, "animation_finished")
	SceneTransition.show_retry_screen()


func invulnerable() -> void:
	hurtArea.set_deferred("monitoring", false)
	suckAlert.set_deferred("monitoring", false)


func _instinct_hint() -> void:
	yield(get_tree(), "idle_frame")
	instinct.show()


func _on_SuckAlert_area_entered(area:Area2D):
	if "Peasants" in area.name:
		canSuck = true
		# Makes sure that the hint is shown before being able to suck
		yield(_instinct_hint(), "completed")
		prey = area


func _on_SuckAlert_area_exited(area:Area2D):
	if "Peasants" in area.name and !isSucking:
		canSuck = false
		instinct.hide()
		if prey == area:
			prey = null


func _on_HurtArea_area_entered(area):
	if area.name == "AttackArea":
		_dead()


func _on_AttackTimer_timeout():
	canAttack = true
