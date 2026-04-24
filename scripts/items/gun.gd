class_name Gun extends RigidBody2D

var is_loaded := false
@onready var hit_ray = $HitRay2D

signal shot
signal yeet
signal damage


func shoot() -> void:
    if is_loaded:
        print("BANG!")
        is_loaded = false
        shot.emit()
        _check_for_hit()
    else:
        print("click")
        yeet.emit()


func _check_for_hit() -> void:
    # if hitray2d is hitting a character, damage them
    if hit_ray.is_colliding():
        var collider = hit_ray.get_collider()
        var other_player = collider as Player
        if other_player:
            damage.emit(other_player)
