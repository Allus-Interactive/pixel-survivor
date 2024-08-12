extends CanvasLayer

signal back_pressed

@onready var win_amount = %WinAmount
@onready var loss_amount = %LossAmount

@onready var damage_amount = %DamageAmount
@onready var health_amount = %HealthAmount
@onready var movement_speed_amount = %MovementSpeedAmount

@onready var back_button = %BackButton

func _ready():
	back_button.pressed.connect(on_back_pressed)
	win_amount.text = str(MetaProgression.get_win_count())
	loss_amount.text = str(MetaProgression.get_loss_count())
	damage_amount.text = "x" + str(MetaProgression.get_player_stat_multiplier("damage"))
	health_amount.text = "x" + str(MetaProgression.get_player_stat_multiplier("health"))
	movement_speed_amount.text = "x" + str(MetaProgression.get_player_stat_multiplier("movement"))

func on_back_pressed():
	ScreenTransition.transition_to_scene("res://scenes/UI/main_menu.tscn")
