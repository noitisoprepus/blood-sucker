extends Control


func _on_PlayButton_pressed():
	SceneTransition.start_main_level()


func _on_AboutButton_pressed():
	SceneTransition.show_about_section()
