extends StaticBody2D

var door_open=true
var rooms = [Global.tutorial, Global.room_1, Global.room_2]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$door_anim.frame=12



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func door_close():
	for room in rooms:
		if room == Global.room_1 and room and door_open:
			await get_tree().create_timer(1.0).timeout
			$door_anim.play_backwards("door_open")
			$AnimationPlayer.play("open_door")
			door_open=false
		if room == Global.room_2 and room and door_open:
			await get_tree().create_timer(1.0).timeout
			$door_anim.play_backwards("door_open")
			$AnimationPlayer.play("open_door")
			door_open=false



func _on_new_map_body_entered(body: Node2D) -> void:
	door_close()
