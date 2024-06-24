class_name MapObject extends Area2D

@onready var game_manager: Node = $/root/MainGame

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += Vector2(-game_manager.speed, 0)
