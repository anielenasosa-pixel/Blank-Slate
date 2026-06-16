extends RigidBody2D

@export var bounce_force: float = 1000.0
@export var torque_force: float = 5000.0
@export var stun_time: float = 1.0

var recovering := false
var recovery_timer := 0.0

@onready var joint: PinJoint2D = $PinJoint2D


func _ready():
	contact_monitor = true
	max_contacts_reported = 5


func _physics_process(delta):
	
	# Handle stun timer
	if recovering:
		recovery_timer -= delta
		
		if recovery_timer <= 0:
			recovering = false
			joint.disabled = false
			
		return



	


func bounce_from_shield(body):
	recovering = true
	recovery_timer = stun_time
	
	# Disable pivot control temporarily
	joint.disabled = true
	
	# Calculate bounce direction
	var bounce_dir = (global_position - body.global_position).normalized()
	
	# Stop current movement for clean bounce
	linear_velocity = Vector2.ZERO
	
	# Apply bounce impulse
	apply_impulse(Vector2.ZERO, bounce_dir * bounce_force)
	
	# Apply spin torque
	apply_torque_impulse(randf_range(-torque_force, torque_force))


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("sheild") and !recovering:
		bounce_from_shield(body)
		
