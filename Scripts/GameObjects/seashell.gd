class_name Seashell extends MapObject

@export var g_direction: int

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	add_to_group("shells")
	if g_direction > 0:
		anim_sprite.flip_v = true
		anim_sprite.offset.y *= -1
	else: 
		anim_sprite.flip_v = false
		anim_sprite.offset.y *= 1

func flip_animation():
	anim_sprite.play("flip")
