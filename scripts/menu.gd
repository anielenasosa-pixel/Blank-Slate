extends Node2D

var showing=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and not showing:
		$".".visible=true
		showing=true
		get_tree().paused = true
	

func _on_button_3_pressed() -> void:
	if showing:
		OS.shell_open("https://forms.gle/xTamkcPN68denTYx7")
		print("whoop")


func _on_button_2_pressed() -> void:
	if showing:
		get_tree().paused = false
		get_tree().reload_current_scene()


func _on_button_pressed() -> void:
	if showing:
		$".".visible=false
		showing=false
		get_tree().paused = false
	
