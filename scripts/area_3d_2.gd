extends Area3D


@onready var game_over: Label = $ui/GameOver
signal respawn


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.name == "CharacterBody":
		print("u respawned yaaaay")
		game_over.visible = false
		respawn.emit()
		# $"../player".global_position = spawn_pos
		
