extends Node2D

class_name Level

var ball_speed_multiplier: float = 1
var ball_speed_limit: int = 40
var last_custom_data: int
var custom_data: int
var last_collider = null
@onready var blue_ball = $BlueBall as Ball
@onready var player_ui = $"Player UI" as UI

func _process(_delta):
	if (Input.is_action_pressed("Left") or Input.is_action_pressed("Right")) and !Globals.is_ball_started:
		blue_ball.set_start_ball_pos()
		
	elif Input.is_action_just_pressed("StartBall") and !Globals.is_ball_started:
		blue_ball.start_ball()
		Globals.is_ball_started = true
		$Paddle/Pointer.hide()
		
	elif Input.is_action_just_pressed("Pause"):
		get_tree().paused = !get_tree().paused
		
func _on_blue_ball_collided(collision):
	var collider = collision.get_collider()
	var new_velocity = Vector2.ZERO
	
	if collider is TileMap:
		var tile_pos = collider.get_coords_for_body_rid(collision.get_collider_rid())   # Get Tile Coordinates
		var tile_data = collider.get_cell_tile_data(0,tile_pos)                         # Extract Tile Data
		custom_data = tile_data.get_custom_data_by_layer_id(0)
		
		if custom_data >= 2:
			collider.erase_cell(0,tile_pos)  # Delete Tile at given coordinates
			Globals.blocks -= 1
			if Globals.blocks == 0:
				print("You Win!")
				get_tree().quit()
		
		blue_ball.velocity = blue_ball.velocity.bounce(collision.get_normal())
				
	elif collider is Paddle:
		ball_speed_multiplier += 0.005
		@warning_ignore("integer_division")
		var collision_x = (blue_ball.position.x - $Paddle.position.x) / (Paddle.PADDLE_WIDTH / 2)
		var magnitude = blue_ball.velocity.length()
		new_velocity.x = magnitude * collision_x
		new_velocity.x = new_velocity.x + ($Paddle.velocity.x * blue_ball.horizontal_deviation)
		new_velocity.y = sqrt(absf((magnitude * magnitude) - (new_velocity.x * new_velocity.x))) * -1
		blue_ball.velocity = (new_velocity * ball_speed_multiplier).limit_length(ball_speed_limit)
	
	if last_collider == collider and last_custom_data == custom_data:
		print("brick Again", last_custom_data, custom_data , last_collider, collider)
		blue_ball.velocity.x = blue_ball.velocity.rotated(deg_to_rad(randf_range(-45,45))).x * 5
		blue_ball.velocity.y = blue_ball.velocity * -1
		last_collider = collider
		last_custom_data = custom_data
		
	blue_ball.velocity = (blue_ball.velocity * ball_speed_multiplier).limit_length(ball_speed_limit)
	
func _on_death_wall_body_entered(body):
	Globals.lives -= 1
	
	if Globals.lives == 0:
		body.queue_free()
		Globals.gameOver = true
		player_ui.showGameOver()
	else:
		reset_ball()
		
func reset_ball():
	Globals.is_ball_started = false
	ball_speed_multiplier = 1
	last_collider = null
	blue_ball.velocity = Vector2.ZERO
	blue_ball.set_start_ball_pos()
	$Paddle/Pointer.show()

func _on_player_ui_retry():
	Globals.gameOver = false
	Globals.is_ball_started = false
	player_ui.hideGameOver()
	Globals.lives = 3
	get_tree().reload_current_scene()
