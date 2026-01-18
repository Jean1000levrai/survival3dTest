extends Area3D

@onready var game_over: Label = $"../ui/GameOver"

var spawn_pos = Vector3(0, 3, 0)

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.name == "CharacterBody":
		print("u respawned yaaaay")
		body.position = spawn_pos
		game_over.visible = false
		
