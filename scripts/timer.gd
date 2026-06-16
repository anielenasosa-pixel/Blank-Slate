extends Label

var countdown_time:int = 120
var running=false

@export var label: Label
@export var timer:Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if countdown_time==0.0:
		$Timer.stop()
		label.text=str("times up")





func _on_timer_timeout() -> void:
	countdown_time-=1
	update_timer()
	$Timer.start()

func update_timer():
	var minutes = countdown_time/60
	var seconds= countdown_time%60
	label.text = "%02d:%02d" % [minutes, seconds]
