extends Node2D

@export var stats: Resource




@onready var sword_body = $Pivot/RigidBody2D # Adjust path to your RigidBody
@onready var timer = $sword_timer

func _ready() -> void:
	# Connect the collision signal
	pass

func _physics_process(delta: float) -> void:
		invisible_bubble()



func invisible_bubble():
	if not Global.pause:
		var max_position = 100
		var hero_position = $"../Hero".global_position
		var mouse_pos = get_global_mouse_position()
		var offset = mouse_pos - hero_position
		
		if offset.length() > max_position:
			offset = offset.normalized() * max_position
			
		$Pivot.global_position = hero_position + offset
