extends PanelContainer

@onready var name_label: Label = %Name
@onready var description_label: Label = %Description
@onready var progress_bar = %ProgressBar
@onready var purchase_button = %PurchaseButton
@onready var progress_label = %ProgressLabel
@onready var count_label = %CountLabel

var upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)

func set_meta_upgrade(_upgrade: MetaUpgrade):
	self.upgrade = _upgrade
	name_label.text = _upgrade.title
	description_label.text = _upgrade.description
	update_progress()

func update_progress():
	var current_quantity = 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
	elif MetaProgression.save_data["player_stats"].has(upgrade.id):
		print("upgrade: " + str(MetaProgression.save_data["player_stats"][upgrade.id]))
		var upgrade_count = MetaProgression.save_data["player_stats"][upgrade.id]
		current_quantity = (upgrade_count - 1) / 0.1
	var is_maxed = current_quantity >= upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / upgrade.exp_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		purchase_button.text = "Max"
	progress_label.text = str(currency) + "/" + str(upgrade.exp_cost)
	count_label.text = "x%d" % current_quantity

func select_card():
	$AnimationPlayer.play("selected")

func on_purchase_pressed():
	if upgrade == null:
		return
	
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.exp_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")
