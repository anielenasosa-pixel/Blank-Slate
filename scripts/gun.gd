extends Node2D

@export var radius: float = 25.0
var paint_package=preload("res://scenes/paint.tscn")
var can_shoot=true
var DISABLED=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	follow_mouse()
	shoot()
	#disable_gun()

func follow_mouse():
	var hero: = get_parent()
	if not hero:
		return
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	var dir=hero.global_position.direction_to(mouse_pos)
	position=dir*radius
	look_at(get_global_mouse_position())
	
	
	if mouse_pos.x < hero.global_position.x:
		scale.y=-1
	else:
		scale.y =1
		
	
func shoot():
	if DISABLED:
		return
	if Input.is_action_just_pressed("click") and can_shoot:
		can_shoot=false
		$can_shoot.start()
		var paint=paint_package.instantiate()
	
		paint.global_position=$muzzle.global_position
		paint.rotation= rotation
		get_tree().current_scene.add_child(paint)
		


func _on_can_shoot_timeout() -> void:
	can_shoot=true

func disable_gun():
	if Global.room_2:
		visible=false
		DISABLED=true
