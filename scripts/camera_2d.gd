extends Camera2D

var shake_intense=0.0
var active_shke_time=0.0

var shake_decay=5.0

var sake_time=0.0
var shake_time_speed=20.0

var noise=FastNoiseLite.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active_shke_time>0:
		sake_time+= delta* shake_time_speed
		active_shke_time-= delta
		
		offset=Vector2(
			noise.get_noise_2d(sake_time, 0)*shake_intense,
			noise.get_noise_2d(0,sake_time)* shake_intense
		)
		
		shake_intense=max(shake_intense-shake_decay*delta,0)
	else:
		offset- lerp(offset, Vector2.ZERO, 10.5*delta)
func screen_shake(intenseity: int, time: float):
	randomize()
	noise.seed=randi()
	noise.frequency=2.0
	
	shake_intense=intenseity
	active_shke_time=time
	sake_time=0.0
