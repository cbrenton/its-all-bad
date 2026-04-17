class_name Player
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player_number: int
var left_input: String
var right_input: String
var jump_input: String
var action_input: String

var fist: Weapon
var weapon: Weapon

var knockback_x: float = 0.0

@onready var visuals: Node2D = $Visuals
@onready var hold_position: Node2D = $Visuals/HoldPosition

var action_rate = 0.5

var fist_scene = preload("res://fist.tscn")

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
	self.weapon = self.fist
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

	# if knockback is significant, disable horizontal input
	if abs(self.knockback_x) < 10.0:
		var direction := Input.get_axis(self.left_input, self.right_input)
		if direction:
			self.velocity.x = direction * SPEED
			self.visuals.scale.x = sign(direction)
		else:
			self.velocity.x = move_toward(self.velocity.x, 0, SPEED)
	else:
		self.velocity.x = 0.0

func _handle_non_movement_input() -> void:
	# TODO: if action just pressed, check action cooldown and act
	if Input.is_action_just_pressed(self.action_input):
		self.weapon.attack()

func attack(target: Player, damage: float) -> void:
	print("attacking p%d" % target.player_number)
	var cur_velocity = target.velocity
	var dir_to_target = sign((target.position - self.position).x)
	var knockback_force = 200

	target.receive_knockback(Vector2(dir_to_target * knockback_force, -200) + self.velocity)

func receive_knockback(force: Vector2) -> void:
	self.knockback_x = force.x
	self.velocity.y = force.y
