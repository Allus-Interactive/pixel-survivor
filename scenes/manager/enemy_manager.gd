extends Node

const SPAWN_RADIUS = 375

# old enemies
# @export var basic_enemy_scene: PackedScene
@export var spider_enemy_scene: PackedScene
@export var slime_enemy_scene: PackedScene
@export var ghost_enemy_scene: PackedScene
@export var cyclops_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene

# new enemies
@export var blue_slime_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene

@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()

var number_to_spawn = 1

func _ready():
	enemy_table.add_item(blue_slime_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated((randf_range(0, TAU)))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * 20
		
		var query_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params)
		
		if result.is_empty():
			# no collisions found, enemy will be spawned inside arena
			break
		else:
			# there is a collision, enemy would be spawned outside of arena. Changing enemy spawn
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position

func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	for i in number_to_spawn:
		var enemy_scene = enemy_table.pick_item()
		var enemy = enemy_scene.instantiate() as Node2D
		
		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		entities_layer.add_child(enemy)
		enemy.global_position = get_spawn_position()

func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	
	# OLD ENEMY TABLE
	## 6 = 30 seconds into the game
	#if arena_difficulty == 6:
		#enemy_table.add_item(spider_enemy_scene, 10)
	## 12 = 60 seconds/1 minute into game
	#elif arena_difficulty == 12:
		#enemy_table.add_item(bat_enemy_scene, 10)
	## 24 = 120 seconds/2 minutes into game
	#elif arena_difficulty == 24:
		#enemy_table.add_item(slime_enemy_scene, 10)
	## 36 = 180 seconds/3 minutes into game
	#elif arena_difficulty == 36:
		#enemy_table.add_item(ghost_enemy_scene, 10)
		#enemy_table.remove_item(basic_enemy_scene)
	## 48 = 240 seconds/4 minutes into game
	#elif arena_difficulty == 48:
		#enemy_table.add_item(cyclops_enemy_scene, 10)
		#enemy_table.remove_item(spider_enemy_scene)
	## continue with elif for each new enemy
	
	### NEW ENEMY TABLE - Add enemies as new ones are created
	# 6 = 30 seconds into the game
	if arena_difficulty == 6:
		pass
		#enemy_table.add_item(spider_enemy_scene, 10)
	# 12 = 60 seconds/1 minute into game
	elif arena_difficulty == 12:
		pass
		enemy_table.add_item(bat_enemy_scene, 5)
	## 24 = 120 seconds/2 minutes into game
	elif arena_difficulty == 24:
		pass
		#enemy_table.add_item(slime_enemy_scene, 10)
	# 36 = 180 seconds/3 minutes into game
	elif arena_difficulty == 36:
		pass
		#enemy_table.add_item(ghost_enemy_scene, 10)
		#enemy_table.remove_item(blue_slime_enemy_scene)
	# 48 = 240 seconds/4 minutes into game
	elif arena_difficulty == 48:
		pass
		#enemy_table.add_item(cyclops_enemy_scene, 10)
		#enemy_table.remove_item(spider_enemy_scene)
	# continue with elif for each new enemy
	
	# TODO revist to fix game balance, amount of enemies can feel too much
	# every minute increase number of enemies spawned per second
	#if (arena_difficulty % 12) == 0:
		#number_to_spawn += 1 
