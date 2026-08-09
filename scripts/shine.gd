extends Node2D

var can_spawn=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.visible=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn():
	if can_spawn:
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
		$Sprite2D.visible=true
		can_spawn=false
		

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Hero"):
		Global.shine_count+=1
		call_deferred("queue_free")
