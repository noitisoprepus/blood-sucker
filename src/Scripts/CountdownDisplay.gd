extends Label

export var countdown: int = 120

var player


func _ready():
	player = get_parent().get_parent().get_node("Player")
	player.connect("death", self, "_on_player_death")


func _process(delta):
	if (countdown <= 0):
		set_text("TIME 00:00")
		SceneTransition.show_completion_screen()
		set_process(false)
		$AudioStreamPlayer.stop()
		player.invulnerable()
	
	var m: int = countdown / 60
	var s: int = countdown % 60
	
	var minutes = str(m)
	var sec = str(s)
	
	if s <= 9:
		sec = "0" + str(s)
	if m <= 9:
		minutes = "0" + str(m)
	set_text("TIME " + str(minutes) + ":" + str(sec))


func _on_player_death():
	set_process(false)
	$AudioStreamPlayer.stop()


func _on_Timer_timeout():
	countdown -= 1
