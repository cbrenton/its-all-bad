class_name Fist extends Node2D

@onready var hitbox: Area2D = $HitArea2D

signal punch_landed(target, attack_dir_x)

var attack_duration: float = 0.1
var attack_timer: Timer
var is_held: bool = false
var attack_rate: float = 0.2


func _ready() -> void:
    print("fist ready")
    print(hitbox)


func _fire(look_dir_x) -> void:
    hitbox.monitoring = true
    await get_tree().physics_frame

    for area in hitbox.get_overlapping_areas():
        _attack_area(area, look_dir_x)

    # TODO: does this actually make this any better?
    await get_tree().create_timer(attack_duration).timeout
    hitbox.monitoring = false


func _attack_area(target: Area2D, look_dir_x: float) -> void:
    # TODO: this is hacky, but it gets the parent's (HoldPosition) parent's (Visuals) parent (Player)
    if target.get_parent() != get_parent().get_parent().get_parent():
        var player = get_parent().get_parent().get_parent() as Player
        var player_num = player.player_number
        print("player %d landed punch while looking %d" % [player_num, look_dir_x])
        punch_landed.emit(target.get_parent(), look_dir_x)


func attack(look_dir_x) -> void:
    if attack_timer == null:
        attack_timer = Timer.new()
        attack_timer.one_shot = true
        add_child(attack_timer)
    if attack_timer.is_stopped():
        _fire(look_dir_x)
        attack_timer.start(attack_rate)
    pass
