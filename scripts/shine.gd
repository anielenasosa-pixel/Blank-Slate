extends Node2D

var can_spawn=true
var shine_follow=0
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



func _on_magnet_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		follow(body)
			
		
func follow(body):
	var tween: Tween = create_tween()
	if shine_follow==0:
		shine_follow+=1
		tween.tween_property(self, "global_position", body.global_position, 0.2)\
			.set_trans(Tween.TRANS_BACK)\
			.set_ease(Tween.EASE_IN)
	else:
		tween.tween_property(self, "global_position", body.global_position, 0.2)\
			.set_ease(Tween.EASE_IN)
		
		


func _on_magnet_body_exited(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		if shine_follow==1:
			follow(body)
