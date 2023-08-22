extends Target

var ACCELERATION := PI / 8
var SPEED_MAX := PI * 1.5
var SPEED_MIN := PI / 2

var acceleration := ACCELERATION 

func move(delta:float):
	if speed <= SPEED_MIN:
		acceleration = ACCELERATION
	elif speed >= SPEED_MAX:
		acceleration = -ACCELERATION
	move_with_acceleration(delta)

func move_with_acceleration(delta:float):
	speed = speed + (acceleration * delta)
	rotation -= speed * delta
