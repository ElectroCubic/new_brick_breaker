extends CharacterBody2D

class_name Paddle

const PADDLE_WIDTH: int = 256
const PADDLE_HEIGHT: int = 64

@export var speed: int
var direction: Vector2

@onready var pointer = $Pointer

func update_paddle_pos():
	Globals.paddlePos = position
	
func update_pointer_angle():
	Globals.pointerAngleInDeg = pointer.rotation_degrees

func _ready():
	update_paddle_pos()

func _process(delta):
	if !Globals.gameOver:
		var left = Input.is_action_pressed("Left")
		var right = Input.is_action_pressed("Right")
	
		if left and not right:
			direction = Vector2.LEFT
		elif right and not left:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.ZERO
			
		if !Globals.is_ball_started:
			var angleUp = Input.is_action_pressed("IncreaseAngle")
			var angleDown = Input.is_action_pressed("DecreaseAngle")

			if angleUp and not angleDown and pointer.rotation_degrees > -160:
				pointer.rotation_degrees -= 1
			elif angleDown and not angleUp and pointer.rotation_degrees < -20:
				pointer.rotation_degrees += 1
			
			update_pointer_angle()
	
		velocity = speed * direction * delta
		update_paddle_pos()
		move_and_collide(velocity)
	
