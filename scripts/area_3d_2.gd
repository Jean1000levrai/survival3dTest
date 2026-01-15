extends Area3D

var spawn_pos = Vector3(0, 2, 0)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		print("u respawned yaaaay")
		$"../Label".visible = false
		$"../player".global_position = spawn_pos
		
