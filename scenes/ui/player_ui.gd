extends CanvasLayer

class_name UI

signal retry

@onready var lives_counter: Label = $LivesDisplay/HBoxContainer/LivesCounter

func _ready():
	Globals.connect("stat_change", update_stat_label)
	hideGameOver()
	update_stat_label()

func update_stat_label():
	updateCounter()

func updateCounter():
	lives_counter.text = "Lives : " + str(Globals.lives)
	
func showGameOver():
	$GameOverDisplay.show()
	
func hideGameOver():
	$GameOverDisplay.hide()

func _on_retry_btn_pressed():
	retry.emit()
