class_name GunOld
extends RigidBody2D

"""
signal hit_landed(target, is_fatal)
signal shot

@onready var raycast: RayCast2D = $HitRay2D
@onready var gunshot_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

# TODO: start false
var is_loaded: bool = true
var attack_duration: float = 0.1
var attack_timer: Timer
var is_thrown: bool = false
var attack_rate: float = 0.2
var holder: Player = null


func _ready() -> void:
    attack_rate = 0.2
    print("gun ready")
    self.contact_monitor = true
    self.max_contacts_reported = 4
    body_entered.connect(_on_body_entered)
    self.continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE


func _on_pickup(player: Player) -> void:
    self.holder = player
    move_to.call_deferred(player)


# TODO: when weapon is held, disable pickup
func move_to(player: Player) -> void:
    self.freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
    self.freeze = true
    reparent(player.hold_position)
    self.position = Vector2.ZERO
    self.rotation = 0

    self.hit_landed.connect(player.attack)


func drop() -> void:
    # TODO: figure out how to do this with fist
    self.freeze = false
    reparent(get_tree().current_scene)
    self.hit_landed.disconnect(self.holder.attack)
    self.holder = null


func _fire() -> void:
    if self.is_loaded:
        self.gunshot_sound.play()
        if raycast.is_colliding():
            print("bam!")
            var other = self.raycast.get_collider() as Player
            if other:
                self.hit_landed.emit(other, true)
        self.is_loaded = false
        self.shot.emit()
    else:
        _throw()


func _throw() -> void:
    var look_dir = sign(self.holder.visuals.scale.x)
    self.holder.clear_weapon()
    drop()
    self.is_thrown = true
    apply_central_impulse(Vector2(look_dir * 2000, -20))


func attack() -> void:
    if self.attack_timer == null:
        self.attack_timer = Timer.new()
        self.attack_timer.one_shot = true
        add_child(self.attack_timer)
    if self.attack_timer.is_stopped():
        _fire()
        self.attack_timer.start(self.attack_rate)


func _on_body_entered(body: Node) -> void:
    var env = body as StaticBody2D
    var player = body as Player

    if env:
        print("gun hit body is ground or wall")
        await get_tree().create_timer(0.5).timeout
        self.is_thrown = false
    elif player and is_thrown:
        print("gun hit player")
        var dir_to_target = sign((player.position - self.position).x)
        var knockback_force = 200
        player.receive_knockback(Vector2(dir_to_target * knockback_force, -200))
    else:
        print("gun hit %s" % body.name)


func is_held() -> bool:
    return self.holder != null
"""
