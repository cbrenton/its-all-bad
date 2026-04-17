extends Node2D


@export var player_scene = preload("res://player.tscn")

func _ready() -> void:
	_start_match()

func _start_match() -> void:
	# spawn players
	# 	for each player, connect player.die to check_for_winner
	# spawn gun, connect gun.shoot to spawn_bullet_delayed
	# spawn bullet delayed
	_spawn_players()
	print("starting game")

func _spawn_players() -> void:
	# TODO: make this use screen space to determine spawn point
	var player_positions = [Vector2(200, 500), Vector2(600, 500)]

	var player_num = 1
	for pos in player_positions:
		# instantiate player
		var player = self.player_scene.instantiate()
		# set player pos and orientation
		player.position = pos
		print("initializing player")
		player.initialize(player_num)
		# TODO: connect player signals
		# add child to scene graph
		add_child(player)
		player_num += 1



func _check_for_winner() -> void:
	# brief async - delete players, gun, bullet
	# display win label? emit signal upwards?
	pass
