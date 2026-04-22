class_name Player
extends CharacterBody2D

signal die(player: Player)

var player_number: int

var knockback_x: float = 0.0

@onready var visuals: Node2D = $Visuals
@onready var hold_position: Node2D = $Visuals/HoldPosition
@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var inventory_component: InventoryComponent = %InventoryComponent
@onready var hurtbox_component: HurtBoxComponent = %HurtBoxComponent


# takes in the player's number (1 for p1, 2 for p2, etc)
func initialize(num: int) -> void:
    # store player number
    player_number = num

    input_component.initialize(num)

    # set up player's signal listeners
    hurtbox_component.pickup_item.connect(inventory_component.pickup)


func _physics_process(delta: float) -> void:
    input_component.update()

    movement_component.direction_x = input_component.movement_x
    movement_component.wants_jump = input_component.jump_pressed
    movement_component.tick(delta)

    inventory_component.look_dir_x = movement_component.look_dir_x
    if input_component.action_pressed:
        inventory_component.shoot()

    """
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
    """


"""
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
"""
