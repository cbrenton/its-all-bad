class_name Gun extends Node

var is_loaded := false

signal shot
signal yeet


func shoot() -> void:
    if is_loaded:
        print("BANG!")
        is_loaded = false
        shot.emit()
    else:
        print("click")
        yeet.emit()
