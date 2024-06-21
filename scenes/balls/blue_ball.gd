extends CharacterBody2D

class_name Ball

signal collided(collision)

@export var speed: int
@export var start_ball_offset_y: Vector2
@export_range(0.0,1.0,0.1) var horizontal_deviation: float

func set_start_ball_pos():
	position = Globals.paddlePos + start_ball_offset_y

func _ready():
	set_start_ball_pos()

func _physics_process(delta):
	var collision = move_and_collide(velocity * speed * delta)
	
	if !collision:
		return
	
	collided.emit(collision)
	
func start_ball():
	set_start_ball_pos()
	randomize()
	
	velocity = Vector2.from_angle(deg_to_rad(Globals.pointerAngleInDeg)) * speed

	
