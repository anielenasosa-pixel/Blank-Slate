extends RigidBody2D

@export var stiffness: float = 900.0       # Snaps it back up quickly
@export var base_damping: float = 35.0     # Smooths out the return
@export var max_spin_speed: float = 20.0   # Caps maximum combat speed

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# 1. Get the direction the sword is currently pointing (using its local Transform)
	# Assumes the blade points up relative to its own local space. Change to transform.x if it points right.
	var current_dir: Vector2 = -global_transform.y 
	
	# 2. Define our target direction (Straight UP in global workspace)
	var target_dir: Vector2 = Vector2.UP
	
	# 3. Calculate the angular error using the cross product 
	# This returns a value between -1 and 1 indicating how far off it is
	var angle_error = current_dir.cross(target_dir)
	
	# 4. Predictive Dampening: If it's moving fast towards the target, brake hard
	var current_damping = base_damping
	# Check if velocity direction matches the error correction direction
	if sign(angle_error) != sign(state.angular_velocity):
		current_damping += abs(state.angular_velocity) * 3.0
	
	# 5. Apply the corrective torque
	var target_torque = (angle_error * stiffness) - (state.angular_velocity * current_damping)
	state.apply_torque(target_torque)
	
	# 6. Smoothly cap velocity so it doesn't break the physics engine
	state.angular_velocity = clamp(state.angular_velocity, -max_spin_speed, max_spin_speed)
