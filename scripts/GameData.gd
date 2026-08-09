extends Node
var save_data = {
		"globo_gave_shield" : false,
		"tips_spoken" : false,
		
		"globo": false,
		"globo_unlocked" : false,
		"powerup2": false,
		"powerup3": false
	}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save_game():
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	
func delete_save():
	if FileAccess.file_exists("user://savegame.json"):
		DirAccess.remove_absolute("user://savegame.json")
		
func load_game():
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		save_data = JSON.parse_string(file.get_as_text())
