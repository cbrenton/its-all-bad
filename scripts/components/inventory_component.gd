class_name InventoryComponent extends Node

var weapon: Node = null
@export var hold_position: Node2D
var look_dir_x := 0.0


func pickup(item: Node):
    var grabbed_gun = item.get_node_or_null("Gun") as Gun
    var grabbed_bullet = item.get_node_or_null("Bullet") as Bullet

    var held_gun = weapon.get_node_or_null("Gun") as Gun if weapon else null
    var held_bullet = weapon.get_node_or_null("Bullet") as Bullet if weapon else null

    # pick up and combine items
    if grabbed_gun:
        if held_bullet:
            held_bullet.queue_free()
            grabbed_gun.is_loaded = true
        weapon = item

        # move item to hold position
        item.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
        item.freeze = true
        item.reparent(hold_position)
        item.position = Vector2.ZERO
        item.rotation = 0
        grabbed_gun.yeet.connect(drop)
    elif grabbed_bullet:
        if held_gun:
            held_gun.is_loaded = true
        else:
            weapon = item
        item.queue_free()


func drop():
    var gun = weapon.get_node_or_null("Gun") as Gun if weapon else null
    if gun:
        weapon.freeze = false
        weapon.reparent(get_tree().current_scene)
        # var look_dir = sign(self.holder.visuals.scale.x)
        weapon.apply_central_impulse(Vector2(look_dir_x * 2000, -20))
        gun.yeet.disconnect(drop)
    weapon = null


func shoot():
    var gun = weapon.get_node_or_null("Gun") as Gun if weapon else null
    if gun:
        gun.shoot()
    else:
        # TODO: fist attack
        pass
