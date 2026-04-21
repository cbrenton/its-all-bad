class_name InputComponent extends Node

var left_input: String
var right_input: String
var jump_input: String
var action_input: String

@onready var movement_x := 0.0
@onready var jump_pressed := false
@onready var action_pressed := false


func initialize(player_number: int) -> void:
    self.left_input = "p%d_left" % player_number
    self.right_input = "p%d_right" % player_number
    self.jump_input = "p%d_jump" % player_number
    self.action_input = "p%d_action" % player_number


func update() -> void:
    self.movement_x = Input.get_axis(self.left_input, self.right_input)

    jump_pressed = Input.is_action_just_pressed(self.jump_input)
    action_pressed = Input.is_action_just_pressed(self.action_input)
