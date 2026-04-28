class_name CollectibleComponent extends Node

var just_thrown := false

"""
func on_thrown() -> void:
    pass

    just_thrown = true

    # don't collide with the thrower for 0.5 seconds
    thrower.add_collision_exception_with(rb)
    print(look_dir_x)

    # TODO: potentially move into something like CollectibleComponent#on_thrown
    await get_tree().create_timer(0.5).timeout
    thrower.remove_collision_exception_with(rb)
    rb.collision_layer = 4
    rb.collision_mask = 1
    gun.collectible_component.just_thrown = false


"""
