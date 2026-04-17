class_name Weapon
extends Node2D

"""
signal hit_landed(target, damage)

var attack_rate = 0.5
var attack_timer: Timer
var is_held: bool = false

func _ready() -> void:
	print("superclass ready")

# should never be called directly, only called via attack()
func _fire() -> void:
	push_error("_fire() not implemented by %s" % self.name)

func _on_pickup(player: Player) -> void:
	push_error("_on_pickup() not implemented by %s" % self.name)

func attack() -> void:
	if self.attack_timer == null:
		self.attack_timer = Timer.new()
		self.attack_timer.one_shot = true
		add_child(self.attack_timer)
	if self.attack_timer.is_stopped():
		_fire()
		self.attack_timer.start(self.attack_rate)
	pass
"""
