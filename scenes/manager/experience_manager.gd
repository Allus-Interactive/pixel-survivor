extends Node

signal exp_updated(current_exp: float, target_exp: float)

const TARGET_EXPERIENCE_GROWTH = 5

var current_exp = 0
var current_level = 1
var target_exp = 5

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)

func increment_experience(number: float):
	current_exp = min(current_exp + number, target_exp)
	exp_updated.emit(current_exp, target_exp)
	if current_exp == target_exp:
		current_level +=1
		target_exp += TARGET_EXPERIENCE_GROWTH
		current_exp = 0
		exp_updated.emit(current_exp, target_exp)

func on_experience_vial_collected(number: float):
	increment_experience(number)
