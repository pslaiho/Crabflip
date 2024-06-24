extends MapObject


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	add_to_group("grounds")
	
	if get_node("Sprite").flip_v == true:
		get_node("CollisionShape2D").position *= -1
