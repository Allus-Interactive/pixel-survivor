extends Node

var save_data: Dictionary = {
	"win_count": 0,
	"loss_count": 0,
	"meta_upgrade_currency": 0,
	"meta_upgrades": {}
}

func _ready():
	GameEvents.experience_vial_collected.connect(on_exp_collected)

func add_meta_upgrade(upgrade: MetaUpgrade):
	if !save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1

func on_exp_collected(number: float):
	save_data["meta_upgrades_currency"] += number
	pass
