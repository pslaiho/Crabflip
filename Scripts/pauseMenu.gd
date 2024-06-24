extends Node

@onready var game_manager: Node = $/root/MainGame

var has_ended: bool = false

signal paused(is_paused)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("jump"):
		if has_ended:
			_restart()
		else:
			_continue()

func _restart():
	get_tree().reload_current_scene()
	
func ended():
	paused.emit(true)
	has_ended = true
	
func _continue():
	get_tree().paused = false
	paused.emit(false)
