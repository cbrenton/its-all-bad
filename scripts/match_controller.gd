extends Node2D

@onready var player_scene = preload("res://scenes/player.tscn")
@onready var gun_scene = preload("res://scenes/gun.tscn")
@onready var bullet_scene = preload("res://scenes/bullet.tscn")

var rng = RandomNumberGenerator.new()


func _ready() -> void:
    _start_match()


func _start_match() -> void:
    _spawn_players()

    _spawn_gun()

    _spawn_bullet()


func _spawn_players() -> void:
    # TODO: make this use screen space to determine spawn point
    var player_positions = [Vector2(200, 500), Vector2(800, 500)]

    var player_num = 1
    for pos in player_positions:
        # instantiate player
        var player = self.player_scene.instantiate()
        # set player pos and orientation
        player.position = pos
        # TODO: connect player signals
        add_child(player)
        player.initialize(player_num)
        player_num += 1
        player.die.connect(_check_for_winner)


func _spawn_gun():
    var gun = self.gun_scene.instantiate()
    gun.position = Vector2(571, 0)
    gun.rotation = rng.randi_range(0, 360)
    gun.apply_central_impulse(Vector2(rng.randi_range(50, 100), 20))
    gun.shot.connect(_spawn_bullet)
    add_child(gun)


func _spawn_bullet():
    await get_tree().create_timer(2.0).timeout

    var bullet = self.bullet_scene.instantiate()
    bullet.position = Vector2(571, 0)
    add_child(bullet)


func _check_for_winner(player: Player) -> void:
    # brief async - delete players, gun, bullet
    # display win label? emit signal upwards?
    print("p%d died" % player.player_number)
