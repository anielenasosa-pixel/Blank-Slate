extends TextureProgressBar

@export var globo_sheild:Resource
var powerup_list=[globo_sheild]
var filled = false
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func decide_which_powerup():
	if not filled:
		for powerup in powerup_list:
			if powerup.chosen==true:
				max_value=powerup.max
				min_value=powerup.min
				filled=true
			break
func value_update():
	pass
