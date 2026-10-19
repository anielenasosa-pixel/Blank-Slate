extends CharacterBody2D
class_name EyeballBullet
var direction = Vector2.ZERO
var speed = 2

var bounce=false

@export var hero_stats: Resource
@export var enemy_stats: Resource
@export var basic_gun: Resource
var attack: bool = false

func _ready() -> void:
	Events.eyeball_bullet_hit_eyeball.connect(hit)

func _process(delta):
	if bounce:
		position.x += -direction.x * speed
		position.y += -direction.y * speed
	else:
		position.x += direction.x * speed
		position.y += direction.y * speed
	
func damage():
	hero_stats.damage(enemy_stats.dmg)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()








func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero"):
		await get_tree().create_timer(0.2).timeout
		queue_free()
	if body.is_in_group("gun"):
		bounce_back()
		

func bounce_back():
	bounce=true
	
	
func hit():
	if bounce:
		queue_free()
			
