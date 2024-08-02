extends Node

const BASE_RANGE = 100
const BASE_DAMAGE = 15

@export var anvil_ability_scene: PackedScene

func _ready():
	$Timer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (direction * randf_range(0, BASE_RANGE))
	
	var query_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params)
	
	if !result.is_empty():
		spawn_position = result["position"]
	
	var anvil_ability_instance = anvil_ability_scene.instantiate() as AnvilAbility
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability_instance)
	anvil_ability_instance.global_position = spawn_position
	anvil_ability_instance.hit_box_component.damage = BASE_DAMAGE
