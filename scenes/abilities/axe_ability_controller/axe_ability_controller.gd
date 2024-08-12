extends Node

@export var axe_ability_scene: PackedScene

var base_damage = 10 * MetaProgression.save_data["player_stats"]["damage"]
var additional_damage_percent = 1
var base_wait_time

func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = base_damage * additional_damage_percent
	

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage_percent = 1 + (current_upgrades["axe_damage"]["quantity"] * 0.1)
	elif upgrade.id == "axe_rate":
		var percent_reduction = current_upgrades["axe_rate"]["quantity"] * 0.05
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
