extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D
@export var death_sprite: Texture2D

func _ready():
	if death_sprite == null:
		$GPUParticles2D.texture = sprite.texture
	else:
		$GPUParticles2D.texture = death_sprite
		
	health_component.died.connect(on_died)

func on_died():
	if owner == null || not owner is Node2D:
		return
	var spawn_position = owner.global_position
	
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	
	global_position = spawn_position
	$AnimationPlayer.play("default")
	$HitRandomAudioPlayerComponent.play_random()
