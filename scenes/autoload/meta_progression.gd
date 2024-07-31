extends Node

const SAVE_DATA_PATH = "user://game.save"

var save_data: Dictionary = {
	"win_count": 0,
	"loss_count": 0,
	"meta_upgrade_currency": 0,
	"meta_upgrades": {}
}

func _ready():
	GameEvents.experience_vial_collected.connect(on_exp_collected)
	load_save_data()

func load_save_data():
	if !FileAccess.file_exists(SAVE_DATA_PATH):
		return
	var file = FileAccess.open(SAVE_DATA_PATH, FileAccess.READ)
	save_data = file.get_var()

func save():
	var file = FileAccess.open(SAVE_DATA_PATH, FileAccess.WRITE)
	file.store_var(save_data)

func add_meta_upgrade(upgrade: MetaUpgrade):
	if !save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1

func on_exp_collected(number: float):
	save_data["meta_upgrade_currency"] += number
