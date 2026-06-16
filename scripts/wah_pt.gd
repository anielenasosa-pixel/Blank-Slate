extends CharacterBody2D



var weapon_attack=false
var you_can_now_take_health=true

var attack=false
@export var hero_stats: Resource
@export var enemy_stats : Resource
@export var basic_sword: Resource
var hero=null

var in_wont_come_out
#for fire
var speed=50

var play_anim=false

var attack1=true
var in_hitbox=false
@onready var shine_package=preload("res://scenes/shine.tscn")

var fire_package=preload("res://scenes/fire.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if hero == null:
		hero = get_tree().get_first_node_in_group("Hero")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look()
	shoot()
	play_animm()





func shoot():
	if Global.pause:
		return
	if in_hitbox and not in_wont_come_out:
		if attack1:
			play_anim=true
			$Popping_out.start()
			$Attack_cooldown.start()
			attack1=false
	

func play_animm():
	if play_anim:
		$AnimatedSprite2D.play("Popping_out")
		
func _on_attack_cooldown_timeout() -> void:
	attack1=true


func spawn_fire():
	if Global.pause:
		return
	var player_position=hero.global_position
	
	var fire=fire_package.instantiate()
	
	fire.position=position
	get_tree().current_scene.add_child(fire)
	var direction=(player_position-fire.position).normalized()
	
	fire.velocity=direction*speed
	
	hero.enemies.append(fire)

func _on_animated_sprite_2d_animation_finished() -> void:
	play_anim=false


func _on_popping_out_timeout() -> void:
	spawn_fire()
	

func look():
	var direction=(hero.global_position-position)
	
	if direction.x>0:
		$AnimatedSprite2D.flip_h=false
	
	else:
		$AnimatedSprite2D.flip_h=true

func lose_health():
	if you_can_now_take_health and ($AnimatedSprite2D.frame<=46 and $AnimatedSprite2D.frame>7):
		if weapon_attack:
			enemy_stats.damage(basic_sword.dmg)
			
			
			#this is so it doesnt deal crazy damage in one go
			$Being_attacked_cooldown.start()
			you_can_now_take_health=false
			dead()


func _on_being_attacked_cooldown_timeout() -> void:
	you_can_now_take_health=true




func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		in_hitbox=true


func _on_hit_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		in_hitbox=false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("sword") and $AnimatedSprite2D.frame<=41 and $AnimatedSprite2D.frame>14:
		var camera= hero.get_node("Camera2D")
		camera.screen_shake(3,0.5)
		weapon_attack=true
		lose_health()
		$AnimatedSprite2D.modulate=Color(255, 255, 255)
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("sword"):
		weapon_attack=false
		$AnimatedSprite2D.modulate=Color(1, 1, 1) 
		
func dead():	
	if enemy_stats.health <= 0:
		var shine = shine_package.instantiate()
		shine.position=position
		get_parent().add_child(shine)
		shine.spawn()
		
		
		
		$CPUParticles2D2.emitting = true
		$AnimatedSprite2D.visible=false
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$hit_box/CollisionShape2D.set_deferred("disabled", true)
		if not $death_timer.is_stopped():
			return  # already started
		$death_timer.start()
		


func _on_death_timer_timeout() -> void:
	call_deferred("queue_free")



func _on_wont_come_out_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		in_wont_come_out=true
		

func _on_wont_come_out_body_exited(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		in_wont_come_out=false
