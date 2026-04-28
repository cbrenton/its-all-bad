class_name Gun extends RigidBody2D

var is_loaded := false
var just_thrown := false
@onready var hit_ray = $HitRay2D
@onready var collectible_component = %CollectibleComponent

signal shot
signal yeet
signal damage
signal boing(strength: float)


func _ready() -> void:
    contact_monitor = true
    max_contacts_reported = 4
    body_entered.connect(_on_body_entered)


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


func _on_body_entered(body: Node) -> void:
    print("FOO")
    if body is Player:
        print("FOO player")
        if collectible_component.just_thrown:
            print("FOO just thrown")
            if body is Player:
                print("FOO hit player")
                body.receive_knockback(Vector2(linear_velocity.x, -300))
                print(linear_velocity.length())
                boing.emit(linear_velocity.length() / 500)
    elif body.name == "Ground":
        collectible_component.just_thrown = false
