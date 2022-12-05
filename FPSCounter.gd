extends Control


func _process(delta: float) -> void:
	$Counter.set_text("FPS " + String(Engine.get_frames_per_second()))
