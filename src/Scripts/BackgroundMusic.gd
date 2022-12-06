extends AudioStreamPlayer

signal muteToggled


func _on_TextureButton_toggled(button_pressed):
	emit_signal("muteToggled")
	self.stream_paused = button_pressed
