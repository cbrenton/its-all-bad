class_name MovementComponent extends Node

@export var body: CharacterBody2D
@export var speed := 500.0
@export var gravity_multiplier := 3.0
@export var jump_velocity := -600.0
@export var visuals: Node2D

var direction_x := 0.0
var wants_jump := false
var look_dir_x := 0.0
var knockback_x := 0.0


func tick(delta: float) -> void:
    knockback_x = move_toward(knockback_x, 0, 800 * delta)

    body.velocity.x = direction_x * speed + knockback_x
    if body.velocity.x != 0.0:
        look_dir_x = sign(body.velocity.x)
        visuals.scale.x = look_dir_x

    # gravity
    if not body.is_on_floor():
        body.velocity.y += body.get_gravity().y * delta * gravity_multiplier

    # jump
    if wants_jump and body.is_on_floor():
        body.velocity.y = jump_velocity
    wants_jump = false

    body.move_and_slide()
