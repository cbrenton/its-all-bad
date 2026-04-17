class_name Gun
extends RigidBody2D

signal hit_landed(target, is_fataFl)

@onready var raycast: RayCast2D = $HitRay2D

# TODO: start false
var is_loaded: bool = true
var attack_duration: float = 0.1
var attack_timer: Timer
var is_held: bool = false
var is_thrown: bool = false
var attack_rate: float = 0.2

func _ready() -> void:
	attack_rate = 0.2
	print("gun ready")

func _on_pickup(player: Player) -> void:
	move_to.call_deferred(player)

# TODO: when weapon is held, disable pickup
func move_to(player: Player) -> void:
	self.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	self.freeze = true
	self.position = Vector2.ZERO
	self.rotation = 0
	reparent(player.hold_position)

	self.is_held = true
	self.hit_landed.connect(player.attack)

func drop() -> void:
	# TODO: figure out how to do this with fist
	self.freeze = false
	reparent(get_tree().current_scene)
	# TODO: fix
	self.is_held = false

func _fire() -> void:
	if self.is_loaded:
		if raycast.is_colliding():
			print("bam!")
			var other = self.raycast.get_collider() as Player
			if other:
				hit_landed.emit(other, true)
		self.is_loaded = false
	else:
		_throw()

func _throw() -> void:
	drop()
	self.is_thrown = true
	apply_central_impulse(Vector2(2000, -20))
	pass

func attack() -> void:
	if self.attack_timer == null:
		self.attack_timer = Timer.new()
		self.attack_timer.one_shot = true
		add_child(self.attack_timer)
	if self.attack_timer.is_stopped():
		_fire()
		self.attack_timer.start(self.attack_rate)
	pass
