extends Control

onready var meter = $TextureProgress
onready var tween = $Tween


func _ready():
	meter.value = 0
	var player = get_parent().get_parent().get_node("Player")
	player.connect("drank_blood", self, "fill_blood")
	player.connect("death", self, "empty_vial")


func fill_blood(amount: float) -> void:
	tween.interpolate_property(meter, "value", meter.value, amount, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()


func empty_vial() -> void:
	tween.interpolate_property(meter, "value", meter.value, 0, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
