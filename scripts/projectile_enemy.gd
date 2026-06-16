extends CharacterBody2D
class_name ProjectileEnemy
var speed=50
var weapon_attack=false
var you_can_now_take_health=true

var hero:CharacterBody2D=null

var knockback_is_happening=false

@export var basic_sword: Resource
@export var hero_stats:Resource
@export var enemy_stats : Resource
var attack=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dead()
	movement(delta)
	

func damage():
	hero_stats.damage(enemy_stats.dmg)
		
		
		

func lose_health():
	if you_can_now_take_health:
		if weapon_attack:
			enemy_stats.damage(basic_sword.dmg)
			
			#this is so it doesnt deal crazy damage in one go
			$Attack_timer.start()
			you_can_now_take_health=false

func dead():
	if enemy_stats.health<=0:
		$CPUParticles2D2.emitting = true
		$AnimatedSprite2D.visible=false
		$CollisionShape2D2.disabled=true
		$Area2D2/CollisionShape2D.disabled=true
		if not $death_timer.is_stopped():
			return  # already started
		$death_timer.start()
		
func movement(delta: float)-> void:
		var player_position=hero.global_position
	
		var player_velocity=hero.velocity 
		var predicted_time=0.3
		var predicted_position=player_position+player_velocity*predicted_time
		var direction= (predicted_position-position).normalized()
		if knockback_is_happening==false:
			velocity=direction*speed
			$AnimatedSprite2D.modulate = Color(1, 1, 1) 
			speed=50
		
		
		#knockback
		if weapon_attack:
			$knockback_timer.start()
			knockback_is_happening=true
			if knockback_is_happening:
				$AnimatedSprite2D.modulate=Color(255, 255, 255)
				speed=250
				velocity=direction*-speed
		
		
		for other_enemy in get_parent().get_children():
			if other_enemy==self:
				continue
			if other_enemy.is_in_group("enemies"):
				var dist=position.distance_to(other_enemy.position)
				if dist <32:
					
					var push=(position-other_enemy.position).normalized()
					velocity+=push*30
			
		move_and_collide(velocity * delta)
		
		if direction.x>0:
			$AnimatedSprite2D.flip_h=true
		else:
			$AnimatedSprite2D.flip_h=false
			







func _on_attack_timer_timeout() -> void:
	you_can_now_take_health=true
	



func _on_area_2d_2_body_entered(body:RigidBody2D) -> void:
	if body.is_in_group("sword"):
		weapon_attack=true
		lose_health()


func _on_area_2d_2_body_exited(body:RigidBody2D) -> void:
	if body.is_in_group("sword"):
		weapon_attack=false


func _on_death_timer_timeout() -> void:
	queue_free()


func _on_knockback_timer_timeout() -> void:
	knockback_is_happening=false
