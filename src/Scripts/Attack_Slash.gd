extends Node2D


func _on_AttackArea_area_entered(area):
	if "Hunter" in area.name:
		area.get_killed()
