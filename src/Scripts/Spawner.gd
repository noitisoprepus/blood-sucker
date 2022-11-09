extends StaticBody2D

signal new_wave_started

onready var spawnTimer_p = $SpawnTimer_p
onready var spawnTimer_h = $SpawnTimer_h

export var spawnDir:= Vector2.ZERO

# Peasant
export var peasant: PackedScene
export var peasantInit: int
export var peasantRate: float
export var minDelay_p: float
export var maxDelay_p: float
var toSpawn_p: int = 0

# Hunter
export var hunter: PackedScene
export var hunterInit: int
export var hunterRate: float
export var minDelay_h: float
export var maxDelay_h: float
var toSpawn_h: int = 0

var spawnLoc
var random = RandomNumberGenerator.new()
var wave: int = 0
var player_dead: bool


func _ready():
	reset()
	spawnLoc = get_parent().get_node("Spawns")
	var player = get_parent().get_node("Player")
	player.connect("death", self, "_on_player_death")
	# Endless mode
	start_wave()


#func _process(delta):
#	if !player_dead:
#		if toSpawn_p == 0 and toSpawn_h == 0:
#			# Start wave timer
#			start_wave()


# For restarting the game
func reset():
#	toSpawn_p = 0
#	toSpawn_h = 0
#	wave = 0
	player_dead = false


func spawn(obj, key) -> void:
	var spawnObj
	
	for i in range(spawnLoc.get_child_count()):
		spawnObj = spawnLoc.get_child(i)
		if spawnObj.visible == false and key in spawnObj.name:
			spawnObj.dir = spawnDir
			spawnObj.position = position
			spawnObj.reset()
			return
	
	spawnObj = obj.instance()
	spawnObj.position = position
	spawnObj.dir = spawnDir
	spawnLoc.add_child(spawnObj)


func _spawn_peasant() -> void:
	spawn(peasant, "Peasant")


func _spawn_hunter() -> void:
	spawn(hunter, "Hunter")


#func _get_spawn_growth(initRate, growthRate) -> int:
#	var spawnRate
#	# Exponential Growth
#	# y = a((1 + b)^x)
#	var rate = pow(1 + growthRate, wave)
#	spawnRate = round(initRate * rate)
#	return int(spawnRate)


func _get_random_spawn_delay(minDelay, maxDelay) -> float:
	var delay: float
	random.randomize()
	delay = random.randf_range(minDelay, maxDelay)
	return delay


func start_wave() -> void:
#	wave += 1
#	toSpawn_p = _get_spawn_growth(peasantInit, peasantRate)
#	toSpawn_h = _get_spawn_growth(hunterInit, hunterRate)
	start_spawn_timer(spawnTimer_p, minDelay_p, maxDelay_p)
	start_spawn_timer(spawnTimer_h, minDelay_h, maxDelay_h)
#	print("Wave " + str(wave) + "\nPesants: " + str(toSpawn_p) + "\nHunters: " + str(toSpawn_h))


func start_spawn_timer(timer, minDelay, maxDelay) -> void:
	timer.wait_time = _get_random_spawn_delay(minDelay, maxDelay)
	timer.start()


func _on_player_death() -> void:
	player_dead = true


func _on_SpawnTimer_p_timeout():
	if !player_dead: # and toSpawn_p != 0:
#		toSpawn_p -= 1
		_spawn_peasant()
		start_spawn_timer(spawnTimer_p, minDelay_p, maxDelay_p)


func _on_SpawnTimer_h_timeout():
	if !player_dead: # and toSpawn_h != 0:
#		toSpawn_h -= 1
		_spawn_hunter()
		start_spawn_timer(spawnTimer_h, minDelay_h, maxDelay_h)
