extends AudioStreamPlayer


func _on_TextureButton_toggled(button_pressed):
	AudioServer.set_bus_mute(0, button_pressed)
