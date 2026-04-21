class_name Player
extends CharacterBody2D

signal die(player: Player)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player_number: int
var left_input: String
var right_input: String
var jump_input: String
var action_input: String

var fist: Fist
var weapon: Gun

var knockback_x: float = 0.0

@onready var visuals: Node2D = $Visuals
@onready var hold_position: Node2D = $Visuals/HoldPosition

var action_rate = 0.5

var fist_scene = preload("res://scenes/fist.tscn")


# takes in the player's number (1 for p1, 2 for p2, etc)
func initialize(num: int) -> void:
    # store player number
    self.player_number = num

    # set up listeners
    self.left_input = "p%d_left" % num
    self.right_input = "p%d_right" % num
    self.jump_input = "p%d_jump" % num
    self.action_input = "p%d_action" % num

    self.fist = self.fist_scene.instantiate()
    self.hold_position.add_child(self.fist)
    self.fist.hit_landed.connect(attack)


func _physics_process(delta: float) -> void:
    # add gravity
    if not is_on_floor():
        self.velocity.y += get_gravity().y * delta

    _handle_movement_input()

    # 200 / 0.25s = 800
    # decay knockback over 0.25s
    self.knockback_x = move_toward(self.knockback_x, 0, 800 * delta)
    self.velocity.x += self.knockback_x

    _handle_non_movement_input()

    move_and_slide()


func _handle_movement_input() -> void:
    if Input.is_action_just_pressed(self.jump_input) and is_on_floor():
        self.velocity.y = JUMP_VELOCITY

    # if knockback is significant, disable horizontal input and set movement velocity to 0 (only knockback should contribute)
    if abs(self.knockback_x) > 10.0:
        self.velocity.x = 0.0
    # otherwise, apply input to get movement velocity
    else:
        var direction := Input.get_axis(self.left_input, self.right_input)
        if direction:
            self.velocity.x = direction * SPEED
            self.visuals.scale.x = sign(direction)
        else:
            self.velocity.x = move_toward(self.velocity.x, 0, SPEED)


func _handle_non_movement_input() -> void:
    if Input.is_action_just_pressed(self.action_input):
        breakpoint
        if self.weapon != null:
            self.weapon.attack()
        else:
            self.fist.attack()


func attack(target: Player, is_fatal: bool) -> void:
    print("attacking p%d" % target.player_number)
    var cur_velocity = target.velocity
    var dir_to_target = sign((target.position - self.position).x)
    var knockback_force = 200

    if !is_fatal:
        target.receive_knockback(Vector2(dir_to_target * knockback_force, -200) + self.velocity)
    else:
        target.die.emit(target)
        print("game over")


# reset velocity.y to received force, and set knockback_x which will decay
func receive_knockback(force: Vector2) -> void:
    self.knockback_x = force.x
    self.velocity.y = force.y


func _on_hurt_area_2d_body_entered(body: Node2D) -> void:
    # TODO: hacky - get parent node2d from rigidbody
    print("player body entered")
    # TODO: revert, but for Item
    var touched_weapon = body as Gun
    if touched_weapon:
        print("ran into weapon")
        # TODO: do I need fist check?
        # TODO: fix
        if !touched_weapon.is_held():
            if !touched_weapon.is_thrown:
                print("picking it pu")
                _pick_up(touched_weapon)
            else:
                touched_weapon.apply_central_impulse(Vector2(200, -200))
        return
    var touched_bullet = body as Bullet
    if touched_bullet:
        print("picked up bullet")
        touched_bullet.queue_free()


func _pick_up(gun: Gun) -> void:
    gun._on_pickup(self)
    self.weapon = gun


func clear_weapon() -> void:
    self.weapon = null
