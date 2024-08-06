extends Node

@export_range(0, 1) var drop_percent: float = 0.5
@export var health_component: Node
@export var exp_vial_scene: PackedScene
@export var health_vial_scene: PackedScene

func _ready():
	(health_component as HealthComponent).died.connect(on_died)

func on_died():
	var adjusted_drop_percent = drop_percent
	var exp_gain_upgrade_count = MetaProgression.get_upgrade_count("exp_gain")
	
	if exp_gain_upgrade_count > 0:
		adjusted_drop_percent += 0.1
	
	if randf() <= adjusted_drop_percent:
		# drop exp vial
		if exp_vial_scene == null:
			return
		
		if not owner is Node2D:
			return
		
		instantiate_vial(exp_vial_scene)
	elif randf() <= adjusted_drop_percent:
		# drop health vial
		if health_vial_scene == null:
			return
		
		if not owner is Node2D:
			return
		
		instantiate_vial(health_vial_scene)

func instantiate_vial(vial_scene: PackedScene):
	var spawn_position = (owner as Node2D).global_position
	var vial_instance = vial_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)
	vial_instance.global_position = spawn_position
