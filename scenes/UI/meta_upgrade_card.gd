extends PanelContainer

@onready var name_label: Label = %Name
@onready var description_label: Label = %Description

func _ready():
	gui_input.connect(on_gui_input)

func set_ability_upgrade(upgrade: MetaUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description

func select_card():
	$AnimationPlayer.play("selected")

func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		select_card()
