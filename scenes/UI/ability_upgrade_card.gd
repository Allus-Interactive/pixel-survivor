extends PanelContainer

@onready var name_label: Label = %Name
@onready var description_label: Label = %Description

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description
