extends Node2D

signal game_started
signal game_stopped

#var betty = preload("res://Sprites/betty.png")
var dante0 = preload("res://Assets/Sprites/dante_0.png")
var dante1 = preload("res://Assets/Sprites/dante_1.png")
var rng = RandomNumberGenerator.new()
var pathChild
var posPathChild
var game_state = "Starting"
var changingScene = false
var ss = 0

func addPathListeners():
	posPathChild = 0
	var childCount = $Node2D/Path2D.get_child_count()
	rng.randomize()
	while posPathChild < childCount:
		pathChild = $Node2D/Path2D.get_child(posPathChild)
		var randNum = int(round(rng.randf_range(0.0, 2.0)))
		if randNum == 1:
			pathChild.get_node("Enemy/Sprite").set_texture(dante0)
		elif randNum == 2:
			pathChild.get_node("Enemy/Sprite").set_texture(dante1)
		
		posPathChild += 1

func _ready():
	addPathListeners()
	game_state = "Started"
	$MusicPlayer.play()
	reset()

func reset():
	PlayerVariables.hasHat = false
	PlayerVariables.hasAcc = false
	PlayerVariables.hasShirt = false
	PlayerVariables.owned = []
	
func _physics_process(_delta):
	if Input.is_key_pressed(KEY_SPACE):
		PlayerVariables.takeScreenshot()
	if game_state == "Started":
		game_state = "Playing"
		emit_signal("game_started")
	elif game_state == "Lost":
		if Input.is_action_pressed("ui_accept") and !changingScene:
			$LossSound.stop()
			changingScene = true
			SceneChanger.change_scene("res://Levels/village.tscn")

func _on_Enemy_grabbed_player():
	game_state = "Lost"
	emit_signal("game_stopped")
	$MusicPlayer.stop()
	$LossSound.play()

func _on_Inventario_full():
	emit_signal("game_stopped")
	$MusicPlayer.stop()
	$WinSound.play()
	
#DEBUG PURPOSES function to test winScreen without playing through the game xd
func _input(_event):
	if (Input.is_action_just_pressed("ui_page_down")):
		PlayerVariables.owned.append("MarineroCamisa.png")
		PlayerVariables.owned.append("MarineroSombrero.png")
		PlayerVariables.owned.append("MarineroAccesorio.png")
		_on_Inventario_full()

func _on_WinSound_finished():
	SceneChanger.change_scene("res://Screens/WinScreen/WinScreen.tscn")
	pass # Replace with function body.
