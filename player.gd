extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player_number: int
var left_input: String
var right_input: String
var jump_input: String
var action_input: String

var action_rate = 0.5

# TODO: delegate to weapon?
var action_timer: Timer

# takes in the player's number (1 for p1, 2 for p2, etc)
func initialize(num: int) -> void:
	# store player number
	self.player_number = num
	# set up listeners
	self.left_input = "p%d_left" % num
	self.right_input = "p%d_right" % num
	self.jump_input = "p%d_jump" % num
	self.action_input = "p%d_action" % num

	self.action_timer = Timer.new()
	self.action_timer.one_shot = true
	add_child(self.action_timer)

func _physics_process(delta: float) -> void:
	# add gravity
	if not is_on_floor():
		self.velocity += get_gravity() * delta

	_handle_input()

	move_and_slide()

func _handle_input() -> void:
	# if jump just pressed, check timer (?) and jump
	if Input.is_action_just_pressed(self.jump_input) and is_on_floor():
		self.velocity.y = JUMP_VELOCITY

	# TODO: if action just pressed, check action cooldown and act
	if Input.is_action_just_pressed(self.action_input):
		_take_action()

	# if left or right, apply force
	# TODO: have different values for accel vs decel (friction)
	var direction := Input.get_axis(self.left_input, self.right_input)
	if direction:
		self.velocity.x = direction * SPEED
	else:
		self.velocity.x = move_toward(velocity.x, 0, SPEED)

func _take_action() -> void:
	if self.action_timer.is_stopped():
		print("boom")
		self.action_timer.start(self.action_rate)
	else:
		print("not ready yet")
