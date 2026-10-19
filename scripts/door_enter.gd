extends Node2D

var door_opened=false
var rooms = [Global.tutorial, Global.room_1, Global.room_2,Global.room_boss]



func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





	


	


func _on_door_open_body_entered(body: Node2D) -> void:
	for room in rooms:
		if body.is_in_group("Hero") and not door_opened:
			if room == Global.tutorial and room and GameData.save_data["globo_unlocked"]:
				$door/door_anim.play("door_open")
				$door/AnimationPlayer.play("open_door")
				$door_open/CollisionShape2D.disabled=true
				door_opened=true
			if room == Global.room_1 and room and Global.shine_count>=5:
				$door/door_anim.play("door_open")
				$door/AnimationPlayer.play("open_door")
				$door_open/CollisionShape2D.disabled=true
				door_opened=true


func _on_new_map_body_entered(body: Node2D) -> void:
	for room in rooms:
		if body.is_in_group("Hero"):
			if room == Global.tutorial and room and GameData.save_data["globo_unlocked"]:
				Events.emit_signal("new_map",577,1728 ,2) #2nd num should be 1728 and 3rd should be 2 if you want boss ,577,1247,1.7
				Global.tutorial = false
				Global.room_1 = true #should be room_1 or boss if you want boss
				Events.emit_signal("entered_door",1) #should be 1 or three if you want boss
			if room == Global.room_1 and room and Global.shine_count>=5:
				Events.emit_signal("new_map",1727,2651 ,1.7)
				Events.emit_signal("kill_all")
				Global.shine_count=0
				Global.room_boss = true
				Global.room_1 = false
				Events.emit_signal("entered_door",3)
	
