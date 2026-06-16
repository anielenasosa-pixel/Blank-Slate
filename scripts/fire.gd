extends CharacterBody2D
class_name WahPtFire
var alive=true


var attack=false
@export var hero_stats: Resource
@export var enemy_stats : Resource
func _ready() -> void:
	$AnimatedSprite2D.visible=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive:
		move_and_slide()
	
		

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Hero"):
		$AnimatedSprite2D.visible=true
		$AnimatedSprite2D.play("explosion")
		$Sprite2D.visible=false
		$PointLight2D.visible=false
		alive=false
		
		

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")


func _on_animated_sprite_2d_animation_finished() -> void:
	call_deferred("queue_free")

func damage():
	hero_stats.damage(enemy_stats.dmg)


		


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("sheild"):
		$AnimatedSprite2D.visible=true
		$AnimatedSprite2D.play("explosion")
		$Sprite2D.visible=false
		$PointLight2D.visible=false
		alive=false
