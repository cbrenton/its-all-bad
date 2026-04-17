extends Weapon

@onready var hitbox: Area2D = $HitArea2D

var attack_duration: float = 0.1

func _ready() -> void:
	attack_rate = 0.2
	print("fist ready")

func _fire() -> void:
	self.hitbox.monitoring = true
	await get_tree().physics_frame

	for area in self.hitbox.get_overlapping_areas():
		_attack_area(area)

	# TODO: does this actually make this any better?
	await get_tree().create_timer(self.attack_duration).timeout
	self.hitbox.monitoring = false

func _attack_area(target: Area2D) -> void:
	# TODO: this is hacky, but it gets the parent's (HoldPosition) parent's (Visuals) parent (Player)
	if target.get_parent() != self.get_parent().get_parent().get_parent():
		print("hit somebody!")
		hit_landed.emit(target.get_parent(), 1.0)
