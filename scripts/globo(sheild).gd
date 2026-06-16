extends Node2D

@export var properties: Resource
signal talking(text_num)
var waiting=false
var can_wait=true
var speed = 25
var going_inside=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameData.save_data["globo_gave_shield"]:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	for point in $Path2D.curve.get_baked_points():
		var global_point = $Path2D.to_global(point)
		if $Path2D/PathFollow2D/globo.global_position.distance_to(global_point) < 1 and can_wait:
			waiting=true 
			can_wait=false
			look()
			break
	if not waiting and not Global.pause and not going_inside:
		$Path2D/PathFollow2D.progress += speed * delta
		
		


func _on_talk_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		emit_signal("talking",1)
		
		
func look():
	print("hello")
	await get_tree().create_timer(1.5).timeout
	
	waiting = false
	await get_tree().create_timer(0.5).timeout
	can_wait=true
	
func go_inside():
	going_inside=true
	$Path2D/PathFollow2D/Globo2.visible=true
	$Path2D/PathFollow2D/globo.visible=false
	$Path2D/PathFollow2D/Globo2/AnimationPlayer.play("shoot_up")
	await $Path2D/PathFollow2D/Globo2/AnimationPlayer.animation_finished
	$Path2D/PathFollow2D/Globo2.visible=false
	$Path2D/PathFollow2D/CPUParticles2D2.emitting = true
	await get_tree().create_timer(1.0).timeout
	visible=false
	GameData.save_data["shield_unlocked"] = true
	GameData.save_data["globo_gave_shield"] = true
	GameData.save_game()
	$"../Scene_transition/AnimationPlayer".play("unlock")
	await wait_for_click()
	$"../Scene_transition/AnimationPlayer".play_backwards("unlock")
	$"../Hero".shield_enabled()
	await $"../Hero".shield_enabled()
	queue_free()
	
func wait_for_click():
	while true:
		if Input.is_action_just_pressed("click"):
			break
		await get_tree().process_frame
	
	
	
