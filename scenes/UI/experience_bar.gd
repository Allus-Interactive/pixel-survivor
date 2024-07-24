extends CanvasLayer

@export var exp_manager: Node
@onready var progess_bar = $MarginContainer/ProgressBar

func _ready():
	progess_bar.value = 0
	exp_manager.exp_updated.connect(on_exp_updated)

func on_exp_updated(current_exp: float, target_exp: float):
	var percent = current_exp / target_exp
	progess_bar.value = percent
