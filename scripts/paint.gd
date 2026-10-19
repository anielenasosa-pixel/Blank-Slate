extends CharacterBody2D

@export var speed: float = 100.0
var alive: bool = true

@onready var hero=$".."

func _ready() -> void:
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.frame = 0

func _physics_process(delta: float) -> void:
	#ddisapear()
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
	if target.is_in_group("enemies") or target.is_in_group("boss_sheild/hitbox") or target.is_in_group("enemy_hit_box"):
		alive = false  # Stops movement in _physics_process
		await get_tree().create_timer(0.1).timeout
		# Show splash frame
		$CPUParticles2D.emitting=true
		$CPUParticles2D2.emitting=true
		$CPUParticles2D3.emitting=true
		$AnimatedSprite2D.visible=false
		$PointLight2D.visible=false
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(1).timeout
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if alive:
		queue_free()

func  disapear():
	if ((global_position.x-hero.global_position.x)>=25 and (position.y-hero.position.y)>=25) or ((position.x-hero.position.x)>=-25 and (position.y-hero.position.y)>=-25) :
		alive = false  # Stops movement in _physics_process
		await get_tree().create_timer(0.1).timeout
		# Show splash frame
		$CPUParticles2D.emitting=true
		$AnimatedSprite2D.visible=false
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(1).timeout
		queue_free()
		
