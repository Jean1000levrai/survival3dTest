extends Node3D

var player_instance: Node

func _ready() -> void:
	var enemy_scene = preload("res://scenes/player.tscn")
	player_instance = enemy_scene.instantiate()
	add_child(player_instance)
	




	
