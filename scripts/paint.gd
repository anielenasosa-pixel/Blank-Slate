extends CharacterBody2D

@export var speed: float = 250.0
var alive: bool = true

func _ready() -> void:
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.frame = 0

func _physics_process(delta: float) -> void:
	if alive:
		position += transform.x * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	_handle_hit(body)

func _on_area_2d_area_entered(area: Area2D) -> void:
	_handle_hit(area)

func _handle_hit(target: Node) -> void:
	if not alive:
		return
		
	# Check if we hit an enemy body OR an enemy's hurtbox Area2D
	var parent_node = target.get_parent()
	if target.is_in_group("enemies") or target.has_method("lose_health") or (parent_node and parent_node.has_method("lose_health")):
		alive = false  # Stops movement in _physics_process
		await get_tree().create_timer(0.1).timeout
		# Show splash frame
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.visible = true
			$AnimatedSprite2D.frame = 1
		if has_node("PointLight2D"):
			$PointLight2D.visible = false
		
		# Disable collision so it can't hit twice
		if has_node("CollisionShape2D"):
			$CollisionShape2D.set_deferred("disabled", true)
		if has_node("Area2D/CollisionShape2D"):
			$Area2D/CollisionShape2D.set_deferred("disabled", true)

		# Fade out and clean up
		await get_tree().create_timer(0.2).timeout
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("fade out")
			await $AnimationPlayer.animation_finished
			
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if alive:
		queue_free()
