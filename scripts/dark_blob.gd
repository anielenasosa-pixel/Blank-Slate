extends CharacterBody2D
class_name DarkBlob

# explosion
@onready var explosion_package = preload("res://scenes/explosion.tscn")
@onready var shine_package = preload("res://scenes/shine.tscn")

signal died

var alive: bool = true
var speed: float = 50.0
var weapon_attack: bool = false
var you_can_now_take_health: bool = true

var hero: CharacterBody2D = null

var knockback_is_happening: bool = false
var knockback_direction: Vector2 = Vector2.ZERO

@export var basic_sword: Resource
@export var hero_stats: Resource
@export var enemy_stats: Resource
@export var basic_gun: Resource
var attack: bool = false

var hit_sheild: bool = false

func _ready() -> void:
	if hero == null:
		hero = get_tree().get_first_node_in_group("Hero")

func _process(delta: float) -> void:
	movement(delta)

func damage() -> void:
	if hero_stats and enemy_stats:
		hero_stats.damage(enemy_stats.dmg)

func lose_health() -> void:
	if alive and you_can_now_take_health:
		if weapon_attack and basic_gun and enemy_stats:
			enemy_stats.damage(basic_gun.dmg)
			weapon_attack = false  # Reset flag immediately
			
			if has_node("timescale"):
				$timescale.start()
				
		if has_node("Attack_timer"):
			$Attack_timer.start()
			
		you_can_now_take_health = false
		dead()

func dead() -> void:
	if enemy_stats and enemy_stats.health <= 0:
		if has_node("CPUParticles2D2"):
			$CPUParticles2D2.emitting = true
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.visible = false
		if has_node("CollisionShape2D2"):
			$CollisionShape2D2.set_deferred("disabled", true)
		if has_node("Area2D/CollisionShape2D"):
			$Area2D/CollisionShape2D.set_deferred("disabled", true)
		if has_node("PointLight2D"):
			$PointLight2D.visible=false
			
		alive = false
		call_deferred("_emit_died")
		if has_node("death_timer") and not $death_timer.is_stopped():
			return
		if has_node("death_timer"):
			$death_timer.start()

func _emit_died() -> void:
	emit_signal("died")
		
func movement(delta: float) -> void:
	if Global.pause or hero == null:
		return

	var player_position = hero.global_position
	var player_velocity = hero.velocity 
	var predicted_time = 0.3
	var predicted_position = player_position + player_velocity * predicted_time
	var direction = (predicted_position - position).normalized()

	if knockback_is_happening:
		velocity = knockback_direction * 250.0
		move_and_collide(velocity * delta)
		return

	velocity = direction * speed
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.modulate = Color(1, 1, 1) 
	speed = 50.0

	if (weapon_attack or hit_sheild) and not knockback_is_happening:
		knockback_is_happening = true
		if has_node("knockback_timer"):
			$knockback_timer.start()

		if hero != null:
			knockback_direction = (global_position - hero.global_position).normalized()

		velocity = knockback_direction * 250.0

	if get_parent():
		for other_enemy in get_parent().get_children():
			if other_enemy == self:
				continue
			if other_enemy.is_in_group("enemies"):
				var dist = position.distance_to(other_enemy.position)
				if dist < 32:
					var push = (position - other_enemy.position).normalized()
					velocity += push * 30.0
		
	move_and_collide(velocity * delta)
	
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.flip_h = (direction.x > 0)

func _on_attack_timer_timeout() -> void:
	Engine.time_scale = 1.0
	you_can_now_take_health = true

func _on_death_timer_timeout() -> void:
	call_deferred("queue_free")

func _on_knockback_timer_timeout() -> void:
	knockback_is_happening = false
	knockback_direction = Vector2.ZERO
	weapon_attack = false

# --- HIT DETECTION FIXES ---

func _register_bullet_hit(node: Node) -> void:
	if alive:
		weapon_attack = true
		
		if hero and hero.has_node("Camera2D"):
			var camera = hero.get_node("Camera2D")
			if camera.has_method("screen_shake"):
				camera.screen_shake(3, 0.5)
				
		lose_health()
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.modulate = Color(255, 255, 255)
			
		if not knockback_is_happening:
			knockback_is_happening = true
			knockback_direction = (global_position - node.global_position).normalized()
			if has_node("knockback_timer"):
				$knockback_timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("gun") or body.is_in_group("sword"):
		_register_bullet_hit(body)

func _on_area_2d_area_entered(area: Area2D) -> void:
	# Catches when the bullet's Area2D enters the blob's Area2D
	var parent = area.get_parent()
	if parent.is_in_group("gun") or parent.is_in_group("sword"):
		_register_bullet_hit(area)
		
	if area.is_in_group("sheild"):
		hit_sheild = true
		if not knockback_is_happening:
			knockback_is_happening = true
			knockback_direction = (global_position - area.global_position).normalized()
			if has_node("knockback_timer"):
				$knockback_timer.start()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("sheild"):
		hit_sheild = false
