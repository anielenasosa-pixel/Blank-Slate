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
var Ptoggled_on=false
var Stoggled_on=false
var SWtoggled_on=false
@onready var PFRAME=$Primary_Button/AnimatedSprite2D
@onready var SFRAME=$Secondary_Button/AnimatedSprite2D
@onready var SWFRAME=$Sword_Button/AnimatedSprite2D



func _ready() -> void:
	visible=false
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	button_pressed()
	inv_buttons_hover()
	Item_lists()

	
func on_off():
	$Primary_ItemList.deselect_all()
	if GameData.save_data.get("globo_unlocked", false):
		$Primary_ItemList.set_item_disabled(0, false)
		$color_equipped_1.frame=0
		if GameData.save_data.get("globo", false):
			$Primary_ItemList.select(0)
			$color_equipped_1.frame=1
	else:
		$Primary_ItemList.set_item_disabled(0, true)
		$color_equipped_1.frame=0
		

func button_pressed():
	if Global.power_menu_on:
		visible=true
		on_off()
		
	else:
		visible=false


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if index == 0:
		if GameData.save_data["globo_unlocked"]:
			GameData.save_data["globo"] = $Primary_ItemList.is_selected(index)


func _on_texture_button_pressed() -> void:
	Global.power_menu_on=false
	Global.pause=false


func inv_buttons_hover():
	if $Primary_Button.is_hovered():
		PFRAME.frame=1
	elif Ptoggled_on:
		PFRAME.frame=2
	elif not Ptoggled_on:
		PFRAME.frame=0
	if $Secondary_Button.is_hovered():
		SFRAME.frame=1
	elif Stoggled_on:
		SFRAME.frame=2
	elif not Stoggled_on:
		SFRAME.frame=0
	if $Sword_Button.is_hovered():
		SWFRAME.frame=1
	elif SWtoggled_on:
		SWFRAME.frame=2
	elif not SWtoggled_on:
		SWFRAME.frame=0
	


func _on_primary_button_pressed() -> void:
	if not Ptoggled_on:
		Ptoggled_on=true
		Stoggled_on=false
		SWtoggled_on=false
	elif Ptoggled_on:
		Ptoggled_on=false
	
func _on_secondary_button_pressed() -> void:
	if not Stoggled_on:
		Ptoggled_on=false
		Stoggled_on=true
		SWtoggled_on=false
	elif Stoggled_on:
		Stoggled_on=false



func _on_sword_button_pressed() -> void:
	if not SWtoggled_on:
		Ptoggled_on=false
		Stoggled_on=false
		SWtoggled_on=true
	elif SWtoggled_on:
		SWtoggled_on=false

func Item_lists():
	if Ptoggled_on:
		$Primary_ItemList.visible=true
	else:
		$Primary_ItemList.visible=false
	if Stoggled_on:
		$Secondary_ItemList.visible=true
	else:
		$Secondary_ItemList.visible=false
	
