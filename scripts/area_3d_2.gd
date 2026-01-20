extends Area3D


var spawn_pos = Vector3(0, 3, 0)

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.name == "CharacterBody":
		print("u respawned yaaaay")
		body.position = spawn_pos
		
		
