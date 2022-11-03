extends CanvasLayer

onready var anim = $AnimationPlayer


func start_main_level() -> void:
	anim.play("blood_drip")
	yield(anim, "animation_finished")
	get_tree().change_scene("res://src/Scenes/MainLevel.tscn")
	anim.play_backwards("blood_drip")


func show_completion_screen() -> void:
	anim.play("show_completion_screen")


func show_retry_screen() -> void:
	anim.play("show_retry_screen")


func _on_Button_pressed():
	anim.play_backwards("show_retry_screen")
	yield(anim, "animation_finished")
	start_main_level()
