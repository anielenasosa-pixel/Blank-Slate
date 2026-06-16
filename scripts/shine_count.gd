extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value=Global.shine_count


func _on_new_map_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
