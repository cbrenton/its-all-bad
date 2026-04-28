extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func shake(duration: float = 0.3, strength: float = 10.0):
    var elapsed = 0.0
    while elapsed < duration:
        var remaining_ratio = 1.0 - (elapsed / duration)
        offset = Vector2(
            randf_range(-strength, strength) * remaining_ratio,
            randf_range(-strength, strength) * remaining_ratio
        )
        elapsed += get_process_delta_time()
        await get_tree().process_frame
        offset = Vector2.ZERO
