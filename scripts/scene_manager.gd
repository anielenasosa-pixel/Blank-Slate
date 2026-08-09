extends Node2D
var rooms={
	"tutorial_package"=preload("res://scenes/tutorial.tscn"),
	"room_1_package"=preload("res://scenes/room_1.tscn"),
	"room_2_package"=preload("res://scenes/room_2.tscn")
	}
var current_room: Node
var transition=false
@onready var room_container = get_tree().current_scene.get_node("room_container")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_room(0)
	Events.entered_door.connect(load_room)
	Events.died_restart.connect(restart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_room(door_num):
	if Global.tutorial and door_num == 0:
		await change_room(rooms["tutorial_package"])
	elif Global.room_1 and door_num == 1:
		await change_room(rooms["room_1_package"])
	elif Global.room_2 and door_num == 2:
		await change_room(rooms["room_2_package"])

		
	
func restart():
	await change_room(rooms["tutorial_package"])

func change_room(room_scene: PackedScene):
	if transition:
		return

	transition = true
	var old_room = current_room
	if is_instance_valid(old_room):
		await get_tree().create_timer(0.5).timeout
		old_room.queue_free()
		await old_room.tree_exited
	current_room = room_scene.instantiate()
	if current_room!=null:
		room_container.add_child(current_room)
	else:
		pass
	transition = false
