class_name HurtBoxComponent extends Node

@export var hurt_area: Area2D
signal pickup_item(item: Node2D)


func _ready() -> void:
    if not hurt_area:
        print("no Area2D configured for hurtbox")
        return
    hurt_area.body_entered.connect(on_body_entered)


func on_body_entered(body: Node) -> void:
    print("hit something")
    if body.get_node_or_null("CollectibleComponent"):
        print("picking up something")
        pickup_item.emit.call_deferred(body)
