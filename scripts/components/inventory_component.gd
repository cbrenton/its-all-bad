class_name InventoryComponent extends Node

var weapon: Node = null
@onready var default_weapon: Node = preload("res://scenes/fist.tscn").instantiate()
@export var hold_position: Node2D
var look_dir_x := 0.0
var has_loose_bullet := false


func _ready():
    add_child(default_weapon)
    default_weapon.reparent(hold_position)
    default_weapon.position = Vector2.ZERO
    default_weapon.rotation = 0


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
        grabbed_gun.yeet.connect(drop)
        var rb = item as RigidBody2D
        rb.collision_layer = 0
        rb.collision_mask = 1
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
    print("picked up")
    item.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
    item.freeze = true
    item.reparent(hold_position)
    item.position = Vector2.ZERO
    item.rotation = 0


func _draw_debug_impulse(origin: Vector2, impulse: Vector2) -> void:
    var dir = impulse.normalized()
    var tip = origin + dir * 100
    var left = tip + Vector2(-dir.y, dir.x).normalized() * 10 - dir * 20
    var right = tip + Vector2(dir.y, -dir.x).normalized() * 10 - dir * 20

    var line = Line2D.new()
    line.add_point(origin)
    line.add_point(tip)
    line.width = 2.0
    line.default_color = Color.RED

    var head = Line2D.new()
    head.add_point(left)
    head.add_point(tip)
    head.add_point(right)
    head.width = 2.0
    head.default_color = Color.RED

    var scene = get_tree().current_scene
    scene.add_child(line)
    scene.add_child(head)
    await get_tree().create_timer(1.0).timeout
    line.queue_free()
    head.queue_free()


func drop(drop_x: float = look_dir_x) -> void:
    # TODO: add this for bullet too
    var gun = weapon as Gun
    """
    if gun == null:
        gun = weapon as Bullet
    """
    if gun:
        weapon.freeze = false
        gun.collectible_component.just_thrown = true
        weapon.reparent(get_tree().current_scene)
        var rb = weapon as RigidBody2D
        var thrower = get_parent() as Player
        rb.collision_layer = 4
        rb.collision_mask = 3

        # don't collide with the thrower for 0.5 seconds
        # thrower.add_collision_exception_with(rb)
        print(look_dir_x)

        var impulse = Vector2(drop_x * 2000, -20)
        _draw_debug_impulse(weapon.global_position, impulse)
        weapon.apply_central_impulse(impulse)
        gun.yeet.disconnect(drop)

        weapon = null

        # TODO: potentially move into something like CollectibleComponent#on_thrown
        await get_tree().create_timer(0.5).timeout
        # thrower.remove_collision_exception_with(rb)
        gun.collectible_component.just_thrown = false


func use_held_weapon() -> void:
    var gun = weapon as Gun
    if gun:
        gun.shoot()
    else:
        print("no gun, using fist")

        default_weapon.attack(look_dir_x)
