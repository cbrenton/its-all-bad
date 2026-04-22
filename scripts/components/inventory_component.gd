class_name InventoryComponent extends Node

var weapon: Node = null
@export var hold_position: Node2D
var look_dir_x := 0.0
var has_loose_bullet := false


func pickup(item: Node):
    # pickup can get called twice. ignore that
    if weapon == item:
        return

    var grabbed_gun = item as Gun
    var grabbed_bullet = item as Bullet

    var held_gun = weapon as Gun

    # pick up and combine items
    if grabbed_gun:
        if has_loose_bullet:
            has_loose_bullet = false
            grabbed_gun.is_loaded = true
        weapon = item

        _pickup.call_deferred(item)
        grabbed_gun.yeet.connect(_drop)
        var rb = item as RigidBody2D
        rb.collision_layer = 0
        rb.collision_mask = 0
    elif grabbed_bullet:
        if held_gun:
            print("loaded")
            held_gun.is_loaded = true
        else:
            print("loosey")
            has_loose_bullet = true
        item.queue_free()


func _pickup(item: Node) -> void:
    # move item to hold position
    item.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
    item.freeze = true
    item.reparent(hold_position)
    item.position = Vector2.ZERO
    item.rotation = 0


func _drop() -> void:
    var gun = weapon as Gun
    if gun:
        weapon.freeze = false
        weapon.reparent(get_tree().current_scene)
        weapon.apply_central_impulse(Vector2(look_dir_x * 2000, -20))
        gun.yeet.disconnect(_drop)

        var rb = weapon as RigidBody2D
        rb.collision_layer = 4
        rb.collision_mask = 3
        weapon = null


func use_held_weapon() -> void:
    var gun = weapon as Gun
    if gun:
        gun.shoot()
    else:
        # TODO: fist attack
        pass
