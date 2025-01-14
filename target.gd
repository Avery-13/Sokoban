extends Area3D
signal box_entered
signal box_exited

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_exited(body):
	if body.name.contains("RigidBody"):
		emit_signal("box_exited")
		print("Box exited target:", name)

func _on_body_entered(body):
	if body.name.contains("RigidBody"):
		emit_signal("box_entered")
		print("Box entered target:", name)
