extends CharacterBody2D

@export var basic_sword: Resource
@export var enemy_stats : Resource


var sheild_on=false
var weapon_attack=false
var hero_entered=false
var switch=true
var sheild_cool=true




func _ready() -> void:
	
	
	$AnimatedSprite2D.visible=false
	$AnimatedSprite2D2.visible=false
	$AnimatedSprite2D.play("idle")
	$CollisionShape2D.disabled=true
	$Area2D/CollisionPolygon2D2_left.disabled=true
	$Area2D/CollisionPolygon2D_right.disabled=true
	begin()
func _process(delta: float) -> void:
	look()
	check_for_WP_sheild()
	

	
func look():
	if hero_entered:
		if $"../AnimatedSprite2D".flip_h==false:
			$AnimatedSprite2D.flip_h=true
			$AnimatedSprite2D2.flip_h=true
			position=Vector2(30,0)
			$AnimatedSprite2D2.position=Vector2(18,-7)
			if sheild_on:
				$Area2D/CollisionPolygon2D2_left.disabled=true
				$Area2D/CollisionPolygon2D_right.disabled=false
			
		else:
			$AnimatedSprite2D.flip_h=false
			$AnimatedSprite2D2.flip_h=false
			position=Vector2(-30,0)
			$AnimatedSprite2D2.position=Vector2(-18,-7)
			if sheild_on:
				$Area2D/CollisionPolygon2D2_left.disabled=false
				$Area2D/CollisionPolygon2D_right.disabled=true
	else:
		if switch:
			$AnimatedSprite2D.flip_h=true
			$AnimatedSprite2D2.flip_h=true
			position=Vector2(30,0)
			$AnimatedSprite2D2.position=Vector2(18,-7)
		else:
			$AnimatedSprite2D.flip_h=false
			$AnimatedSprite2D2.flip_h=false
			position=Vector2(-30,0)
			$AnimatedSprite2D2.position=Vector2(-18,-7)
			
func check_for_WP_sheild():
	if sheild_cool==false:
		$AnimatedSprite2D2.visible=true
		$AnimatedSprite2D2.play("sheild")
	
func begin():
		$CollisionShape2D.disabled=false
		$AnimatedSprite2D.visible=true
		$AnimatedSprite2D.play("teleport")
		$spawn_timer.start()
		
func _on_spawn_timer_timeout() -> void:\
	$AnimatedSprite2D.play("idle")


func _on_area_2d_body_entered(body:RigidBody2D) -> void:
	if body.is_in_group("sword"):
		weapon_attack=true
	
		lose_durability()


func _on_area_2d_body_exited(body:RigidBody2D) -> void:
	weapon_attack=false

func lose_durability():
	if weapon_attack:
		enemy_stats.damage(basic_sword.dmg)
		

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		sheild_on=true
		hero_entered=true

func _on_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		hero_entered=false


func _on_switch_timeout() -> void:
	switch=false
	$switch2.start()


func _on_switch_2_timeout() -> void:
	switch=true
	$switch.start()

func _on_sheild_cool_timeout() -> void:
	sheild_cool=false
	$sheild_cool2.start()


func _on_sheild_cool_2_timeout() -> void:
	sheild_cool=true
	
	$AnimatedSprite2D2.visible=false
	$sheild_cool.start()
	
