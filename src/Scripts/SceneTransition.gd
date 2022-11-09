extends CanvasLayer

onready var anim = $AnimationPlayer

var currentTrans: String
var isPlaying: bool


func start_main_level() -> void:
	anim.play("blood_drip")
	yield(anim, "animation_finished")
	start_level()
	anim.play_backwards("blood_drip")


func start_level() -> void:
	get_tree().change_scene("res://src/Scenes/MainLevel.tscn")


func show_completion_screen() -> void:
	currentTrans = "show_completion_screen"
	anim.play(currentTrans)


func show_retry_screen() -> void:
	currentTrans = "show_retry_screen"
	anim.play(currentTrans)


func _on_Button_pressed():
	if !isPlaying:
		isPlaying = true
		start_level()
		anim.play_backwards(currentTrans)
		yield(anim, "animation_finished")
		isPlaying = false
		currentTrans = ""
