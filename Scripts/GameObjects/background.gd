extends Sprite2D

@onready var game_manager: Node = $/root/MainGame

var bg_tiles = [
	preload("res://Sprites/bg1.png"),
	preload("res://Sprites/bg2.png"),
	preload("res://Sprites/bg3.png")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += Vector2(-game_manager.speed / 3, 0)
	if position.x < -200:
		position.x += 954
		texture = bg_tiles.pick_random()
	
