extends Area2D

@onready var debug_txt: Label = $/root/MainGame/Debug

var sounds = {
	"flip": preload("res://Sfx/flip.wav"),
	"hit": preload("res://Sfx/hit.wav"),
	"jump": preload("res://Sfx/jump.wav"),
	"collect": preload("res://Sfx/collect.wav")
}
@onready var audio_stream: AudioStreamPlayer2D = $AudioStream
@onready var anim_sprite: AnimatedSprite2D = $CrabAnimation

const JUMP_CD_MAX = 0.5

var g_scale: float = 2.5
var jump_force: float = -1.8
var jump_cd: float = 0.0


var velocity: float = 0
var is_grounded: bool = false
var game_over: bool = false

signal score_points(amount)
signal game_ended

func _ready():
	anim_sprite.play("run")

func _physics_process(delta):
	var overlapping = false
	for body in get_overlapping_areas():
		if body.is_in_group("grounds"):
			overlapping = true
			break
	is_grounded = overlapping
	
	if not is_grounded or jump_cd > 0:
		velocity += g_scale * delta
		rotation += 0.04 + abs(velocity) * 0.04
	else:
		velocity = 0
		if anim_sprite.animation == "jump":
			anim_sprite.play("run")
			rotation = 0

	if jump_cd > 0:
		jump_cd -= delta
	position += Vector2(0, velocity)



func _on_body_entered(body):
	if body.is_in_group("barrels"):
		_die()
		
	if body.is_in_group("stars"):
		_collect_star(body)
		
	if body.is_in_group("shells"):
		_flip(body)
		
	if body.is_in_group("bounds"):
		_die()


func jump():
	if is_grounded and jump_cd <= 0:
		jump_cd = 0.5
		velocity = jump_force
		_play_sound("jump")
		anim_sprite.play("jump")
		

func _flip(body: Area2D):
	if (g_scale > 0 and velocity > 0) or (g_scale < 0 and velocity < 0):
		jump_cd = 0.5
		g_scale = abs(g_scale) * body.g_direction
		jump_force = -abs(jump_force) * body.g_direction
		velocity = -jump_force * 1.5
		_play_sound("flip")
		body.flip_animation()
		if g_scale < 0:
			anim_sprite.flip_v = true
		else:
			anim_sprite.flip_v = false

func _die():
	_play_sound("hit")
	game_ended.emit()
	
func _collect_star(body):
	body._delete()
	score_points.emit(1)
	_play_sound("collect")

func _play_sound(key: String):
	audio_stream.stream = sounds[key]
	audio_stream.play()
