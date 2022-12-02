extends AudioStreamPlayer

signal muteToggled

func toggle_mute():
	self.stream_paused = !self.stream_paused


func _on_Button_pressed():
	emit_signal("muteToggled")
	toggle_mute()
