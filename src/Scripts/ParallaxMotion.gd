extends ParallaxLayer

export var speed: float = 3.0


func _process(delta):
	motion_offset.x += speed * delta
