class_name Fist
extends Node2D

signal hit_landed(target, is_fatal)

@onready var hitbox: Area2D = $HitArea2D

var attack_duration: float = 0.1
var attack_timer: Timer
var is_held: bool = false
var attack_rate: float = 0.2


func _ready() -> void:
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
        hit_landed.emit(target.get_parent(), false)


func attack() -> void:
    if self.attack_timer == null:
        self.attack_timer = Timer.new()
        self.attack_timer.one_shot = true
        add_child(self.attack_timer)
    if self.attack_timer.is_stopped():
        _fire()
        self.attack_timer.start(self.attack_rate)
    pass
