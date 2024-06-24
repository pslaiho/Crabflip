extends Node

const MAX_SPEED: float = 5.0

var speed: float = 1.5
var score: int = 0
var time_to_inc: float = 10

var game_over = false


signal jumped
signal scored(score)
signal ended

func _ready():
	get_tree().paused = true
	
func _physics_process(delta):
	if speed < MAX_SPEED:
		time_to_inc -= delta
		if time_to_inc < 0:
			time_to_inc += 6
			speed += 0.1
		

func _input(event):
	if Input.is_action_just_pressed("jump"):
		jumped.emit()

func _score(points):
	score += points
	scored.emit(score)

func _game_ended():
	get_tree().paused = true
	game_over = true
	ended.emit()
