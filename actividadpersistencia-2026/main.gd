extends Control

var save_path = "user://save_game.json"
var game_data : Dictionary

func _on_save_01_pressed() -> void:
	save_game(1)

func _on_load_01_pressed() -> void:
	load_game_v1()

func _on_save_03_pressed() -> void:
	save_game(3)

func _on_load_03_pressed() -> void:
	load_game_v3()


func save_game(version: int):
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	match version:
		1:
			game_data = {
			"BGM" : %BGM.stream_paused,
			"Version" : version,
			"Score" : %FrogIdle.currentScore
			}
		3:
			game_data = {
			"BGM" : %BGM.stream_paused,
			"Version" : version,
			"Score" : %FrogIdle.currentScore,
			"pos_x" : %FrogIdle.position.x,
			"pos_y" : %FrogIdle.position.y,
			"SFX" : %FrogIdle.sfx_enabled
			}
	
	save_file.store_string(JSON.stringify(game_data))

func load_game_v1():
	if not FileAccess.file_exists(save_path):
		return

	var save_file = FileAccess.open(save_path, FileAccess.READ)
	game_data = JSON.parse_string(save_file.get_as_text())

	var save_version = int(game_data.get("Version"))

	if save_version != 1:
		print("ERROR: guardado incompatible con versión actual")
		return

	%BGM.stream_paused = game_data["BGM"]
	%FrogIdle.currentScore = game_data["Score"]
	%Score.text = "SCORE: %d" % [int(%FrogIdle.currentScore)]
	
	print("Versión cargada:", save_version)

func load_game_v3():
	if not FileAccess.file_exists(save_path):
		return

	var save_file = FileAccess.open(save_path, FileAccess.READ)
	game_data = JSON.parse_string(save_file.get_as_text())
	
	var save_version = int(game_data.get("Version"))

	match save_version:
		1:
			%BGM.stream_paused = game_data["BGM"]
			%FrogIdle.currentScore = game_data["Score"]
			
			#Datos nuevos 
			%FrogIdle.position = %FrogIdle.position
			%FrogIdle.target = %FrogIdle.target
			%FrogIdle.sfx_enabled = true

		3:
			%BGM.stream_paused = game_data["BGM"]
			%FrogIdle.currentScore = game_data["Score"]
			%FrogIdle.position.x = game_data["pos_x"]
			%FrogIdle.position.y = game_data["pos_y"]
			%FrogIdle.target = Vector2(game_data["pos_x"],game_data["pos_y"]) #para evitar que vuelva a pos previa
			%FrogIdle.sfx_enabled = game_data["SFX"]
	
	%Score.text = "SCORE: %d" % [int(%FrogIdle.currentScore)]
	print("Versión cargada:", save_version)
