extends RigidBody3D

func destroy() -> void:
	queue_free()
