extends Node2D

@onready var powerups = [
				GameData.save_data.get("globo"),
				GameData.save_data.get("globo_unlocked"),
				GameData.save_data.get("powerup2"), 
				GameData.save_data.get("powerup3")
			]
var selected_powerups = []
var MAX_POWERUPS = 3
var locked_powerups = [1,2,3,4,5]



func _ready() -> void:
	visible=false
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	button_pressed()

	
func on_off():
	$ItemList.deselect_all()
	if GameData.save_data.get("globo_unlocked", false):
		$ItemList.set_item_disabled(0, false)
		if GameData.save_data.get("globo", false):
			$ItemList.select(0)
	else:
		$ItemList.set_item_disabled(0, true)
		

func button_pressed():
	if Global.power_menu_on:
		visible=true
		on_off()
		
	else:
		visible=false


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if index == 0:
		if GameData.save_data["globo_unlocked"]:
			GameData.save_data["globo"] = $ItemList.is_selected(index)


func _on_texture_button_pressed() -> void:
	Global.power_menu_on=false
