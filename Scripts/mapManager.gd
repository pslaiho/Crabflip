extends Node

@onready var game_manager: Node = $/root/MainGame
@onready var debug_txt: Label = $/root/MainGame/Debug


var ground_tile = preload("res://Scenes/ground_tile.tscn")
var barrel = preload("res://Scenes/barrel.tscn")
var star = preload("res://Scenes/star.tscn")
var shell = preload("res://Scenes/seashell.tscn")

var last_gt: Area2D
var last_rt: Area2D

var counter_to_gap_b: int = 0
var gap_width_b: float = 0
var gap_end_b: Area2D

var counter_to_gap_t: int = 0
var gap_width_t: float = 0
var gap_end_t: Area2D

const tile_width: int = 16
const map_height: int = 180

const tile_offset: int = 8
const barrel_offset: int = 28
const star_offset: int = 28
const shell_offset: int = 16

@onready var spawn_pos_x: int = 320 + game_manager.speed * 80

var rnd = RandomNumberGenerator.new()
var obj_seed = 0

@onready var ot_min: float = 2
@onready var ot_max: float = 4
@onready var obj_timer_b: float = 0
var spawn_to_b: bool = true
@onready var obj_timer_t: float = rnd.randf_range(ot_min, ot_max)
var spawn_to_t: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(0, spawn_pos_x, tile_width):
		spawn_object(ground_tile, Vector2(x, map_height - tile_offset))
		spawn_object(ground_tile, Vector2(x, tile_offset), true)

	last_gt = spawn_object(ground_tile, Vector2(spawn_pos_x, map_height - tile_offset))
	gap_end_b = last_gt
	last_rt = spawn_object(ground_tile, Vector2(spawn_pos_x, tile_offset), true)
	gap_end_t = last_rt
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_pos_x = 320 + game_manager.speed * 80

	if last_gt.position.x < spawn_pos_x:
		last_gt = spawn_object(ground_tile, Vector2(last_gt.position.x + tile_width, map_height - tile_offset))
		if counter_to_gap_b > 0:
			counter_to_gap_b -= 1
		if counter_to_gap_b == 0 and gap_width_b > 0:
			last_gt.position.x += gap_width_b
			gap_width_b = 0
			gap_end_b = last_gt
		
	if last_rt.position.x < spawn_pos_x:
		last_rt = spawn_object(ground_tile, Vector2(last_rt.position.x + tile_width, tile_offset), true)
		if counter_to_gap_t > 0:
			counter_to_gap_t -= 1
		if counter_to_gap_t == 0 and gap_width_t > 0:
			last_rt.position.x += gap_width_t
			gap_width_t = 0
			gap_end_t = last_rt
	
	obj_timer_b -= delta
	obj_timer_t -= delta
	
	if gap_end_b.position.x > 320:
		spawn_to_b = false
	else: 
		spawn_to_b = true
	
	
	if spawn_to_b:
		if obj_timer_b <= 0:
			obj_seed = rnd.randf()
			if obj_seed < 0.4:
				spawn_barrel_b()
			elif obj_seed < 0.7:
				spawn_shell_b()
			else:
				spawn_hole_b()
			obj_timer_b = rnd.randf_range(ot_min, ot_max)
			
	if gap_end_t.position.x > 320:
		spawn_to_t = false
	else: 
		spawn_to_t = true
			
	if spawn_to_t:
		if obj_timer_t <= 0:
			obj_seed = rnd.randf()
			if obj_seed < 0.4:
				spawn_barrel_t()
			elif obj_seed < 0.7:
				spawn_shell_t()
			else:
				spawn_hole_t()
			obj_timer_t = rnd.randf_range(ot_min, ot_max)
	
func spawn_object(object_type: PackedScene, position: Vector2, flipped_v: bool = false):
	var obj_inst: Area2D = object_type.instantiate() 
	obj_inst.position = position
	
	if flipped_v:
		obj_inst.get_node("Sprite").flip_v = true
		
	add_child(obj_inst)
	return obj_inst

func spawn_barrel_b():
	var barrel_count = rnd.randi_range(1, game_manager.speed)
	spawn_object(barrel, Vector2(spawn_pos_x, map_height - barrel_offset))
	for x in range(1, barrel_count):
		spawn_object(barrel, Vector2(spawn_pos_x + 18 * x,  map_height - barrel_offset))
		
	#spawn_object(star, Vector2(spawn_pos_x - 40 * game_manager.speed + 9 * (barrel_count - 1), map_height - star_offset))
	#spawn_object(star, Vector2(spawn_pos_x + 40 * game_manager.speed + 9 * (barrel_count - 1), map_height - star_offset))
	spawn_object(star, Vector2(spawn_pos_x + 9 * (barrel_count - 1), map_height - star_offset - barrel_offset))

func spawn_shell_b():
	var shell_inst = spawn_object(shell, Vector2(spawn_pos_x, map_height - shell_offset))
	shell_inst.g_direction = -1
	spawn_object(star, Vector2(spawn_pos_x - 80 * game_manager.speed, map_height - star_offset))
	#spawn_object(star, Vector2(spawn_pos_x, map_height - star_offset))
	spawn_object(star, Vector2(spawn_pos_x + 20 * game_manager.speed, map_height / 2))
	#spawn_object(star, Vector2(spawn_pos_x + 40 * game_manager.speed, star_offset), true)
	
	var gap_seed = rnd.randf()
	if gap_seed > 0.3:
		gap_width_b = rnd.randi_range(8, 48) * 16 * game_manager.speed
		counter_to_gap_b = rnd.randi_range(1, 5)
		
		obj_timer_t = rnd.randf_range(ot_min, ot_max)
		if last_rt.position.x > spawn_pos_x:
			last_rt.position.x = spawn_pos_x
		

func spawn_hole_b():
	var width = rnd.randf_range(2.5, 5) * 16 * game_manager.speed
	var old_pos_x = last_gt.position.x - 16
	last_gt.position.x += width
	#spawn_object(star, Vector2(old_pos_x, map_height - star_offset))
	spawn_object(star, Vector2(old_pos_x + (width + 16) / 2, map_height - star_offset - barrel_offset)) 
	gap_end_b = last_gt
	#spawn_object(star, Vector2(last_gt.position.x, map_height - star_offset)) 
	#spawn_object(star, Vector2(spawn_pos_x - 16, map_height - star_offset)) 
	#spawn_object(star, Vector2(spawn_pos_x + 64 * game_manager.speed + 16, map_height - star_offset)) 

func spawn_barrel_t():
	var barrel_count = rnd.randi_range(1, game_manager.speed)
	spawn_object(barrel, Vector2(spawn_pos_x, barrel_offset), true)
	for x in range(0, barrel_count):
		spawn_object(barrel, Vector2(spawn_pos_x + 18 * x,  barrel_offset), true)
		
	#spawn_object(star, Vector2(spawn_pos_x - 40 * game_manager.speed + 9 * (barrel_count - 1), star_offset), true)
	#spawn_object(star, Vector2(spawn_pos_x + 40 * game_manager.speed + 9 * (barrel_count - 1), star_offset), true)
	spawn_object(star, Vector2(spawn_pos_x + 9 * (barrel_count - 1), star_offset + barrel_offset), true)

func spawn_shell_t():
	var shell_inst = spawn_object(shell, Vector2(spawn_pos_x, shell_offset), true)
	shell_inst.g_direction = 1
	spawn_object(star, Vector2(spawn_pos_x - 80 * game_manager.speed, star_offset), true)
	#spawn_object(star, Vector2(spawn_pos_x, star_offset), true)
	spawn_object(star, Vector2(spawn_pos_x + 20 * game_manager.speed, map_height / 2), true)
	#spawn_object(star, Vector2(spawn_pos_x + 40 * game_manager.speed, map_height - star_offset))
	
	var gap_seed = rnd.randf()
	if gap_seed > 0.3:
		gap_width_t = rnd.randi_range(8, 48) * 16 * game_manager.speed
		counter_to_gap_t = rnd.randi_range(1, 5)
		
		obj_timer_b = rnd.randf_range(ot_min, ot_max)
		if last_gt.position.x > spawn_pos_x:
			last_gt.position.x = spawn_pos_x

func spawn_hole_t():
	var width = rnd.randf_range(2.5, 5) * 16 * game_manager.speed
	var old_pos_x = last_rt.position.x - 16
	last_rt.position.x += width
	#spawn_object(star, Vector2(old_pos_x, map_height - star_offset))
	spawn_object(star, Vector2(old_pos_x + (width + 16) / 2, star_offset + barrel_offset), true) 
	gap_end_t = last_rt
	#spawn_object(star, Vector2(last_gt.position.x, map_height - star_offset)) 
	#spawn_object(star, Vector2(spawn_pos_x - 16, map_height - star_offset)) 
	#spawn_object(star, Vector2(spawn_pos_x + 64 * game_manager.speed + 16, map_height - star_offset)) 
