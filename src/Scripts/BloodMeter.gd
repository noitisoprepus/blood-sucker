extends Control

onready var meter = $TextureProgress
onready var player = get_parent().get_parent().get_node("Player")


func _ready():
	meter.value = 0
	player.connect("drank_blood", self, "fill_blood")
	player.connect("death", self, "empty_vial")


func fill_blood(amount: float) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(meter, "value", amount, 1.0)


func empty_vial() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(meter, "value", 0.0, 2.0)
