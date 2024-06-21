extends Node

signal stat_change

var is_ball_started: bool = false
var gameOver: bool = false
var blocks: int
var paddlePos: Vector2
var pointerAngleInDeg: float

var lives: int = 3:
	set(value):
		lives = value
		stat_change.emit()
